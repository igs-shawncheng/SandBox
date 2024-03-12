require "cocos.cocos2d.json"

local DownloadView = class("DownloadView", cc.load("mvc").ViewBase)

DownloadView.RESOURCE_FILENAME = "Platform/downloadView/DownloadView.csb"
DownloadView.RESOURCE_BINDING = {
    ["BG"] = {
        ["varname"] = "m_Background",
    },
    ["LoadingBar"] = {
        ["varname"] = "m_LoadingBar",
    },
    ["LoadingText"] = {
        ["varname"] = "m_LoadingText",
    },
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.DOWNLOAD,
}

local State = {
    INIT = 0,
    START = 1,
    CHECK_PROGRESS = 2,
    NONE = 3,
    FAIL = 4,
}

function DownloadView:onCreate()
    print("DownloadView:onCreate")
    self.m_state = cc.exports.FiniteState:create( State.INIT )
    self.newVersion = 0 -- download version
    self.localVersion = 0
    self:Init()
    self:RegisterEvent()
end

function DownloadView:Init()
    self.m_LoadingBar:setPercent(0)
    self:setVisible( false )
end

function DownloadView:RegisterEvent()
    print("DownloadView:RegisterEvent")

    local function eventHander( event )
        print("DownloadView:event", event)
        if event:getEventName() == tostring( cc.exports.define.EVENTS.DOWNLOAD ) then
            self:OnDownload()
        end
    end

    for _, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function DownloadView:OnUpdate(dt)
    Switch( self.m_state:Tick(), 
    {
        [State.INIT] = function()
            if self.m_state:IsEntering() then
                print("Init download")
            end
        end,
        [State.START] = function()
            if self.m_state:IsEntering() then
                print("Downloading started")
                Inanna.GetDownloader():Start()
                self.m_state:Transit(State.CHECK_PROGRESS)
            end
        end,
        [State.CHECK_PROGRESS] = function ()
            if self.m_state:IsEntering() then
                print("Checking progress")
            end
            self:CheckProgress()
        end,
        [State.NONE] = function()
            if self.m_state:IsEntering() then
                print("Standby mode")
                self.SandBoxSystem = cc.SubSystemBase:GetInstance():GetSystem(cc.exports.SystemName.SandBoxSystem)
                self.SandBoxSystem:RequestStartGame()
            end
        end,
    })
end

function DownloadView:OnDownload()
    self.m_state:Transit(State.START)
end

function DownloadView:CheckProgress()
    local progress = Inanna.GetDownloader():GetProgress()
    self:UpdateProgress(progress)

    if progress > 0 and not self:isVisible() then
        self:setVisible(true)
    end

    if progress == 100 then
        print("Downloading finished")
        self:setVisible(false)
        self.m_state:Transit(State.NONE)
    end
end

function DownloadView:UpdateProgress(progress)
    self.m_LoadingBar:setPercent(progress)
    progress = math.floor(progress * 100 + 0.5) / 100
    local loadingText = progress .. "%"
    self.m_LoadingText:setString(loadingText)
end

function DownloadView:OnEnter()
    print("DownloadView:OnEnter()")
    self:setVisible( false )
end

function DownloadView:OnExit()
    print("DownloadView:OnExit()")
end

return DownloadView