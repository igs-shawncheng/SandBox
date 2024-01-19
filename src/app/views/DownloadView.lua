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
    DOWNLOAD_VERSION_DATA = 1,
    CHECK_VERSION_WAIT = 2,
    DOWNLOAD_GAME_DATA = 3,
    NONE = 4,
}

local LocalVersionState = {
    ERROR = 0,
    EXIST = 1,
    NOT_EXIST = 2,
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
        [State.DOWNLOAD_VERSION_DATA] = function()
            if self.m_state:IsEntering() then
                print("Download version data")
                self:DownLoadVersionData()
            end
        end,
        [State.CHECK_VERSION_WAIT] = function()
            if self.m_state:IsEntering() then
                print("Check version")
                self:CheckCustomVersionSame()
            end
        end,
        [State.DOWNLOAD_GAME_DATA] = function()
            if self.m_state:IsEntering() then
                print("Download game data")
                self:DownLoadGameData()
            end
        end,
        [State.NONE] = function()
            if self.m_state:IsEntering() then
                print("Standby mode")
            end
        end,
    })
end

function DownloadView:OnDownload()
    self.m_state:Transit(State.DOWNLOAD_VERSION_DATA)
end

function DownloadView:DownLoadVersionData()
    -- download new version file
    Inanna.GetDownloader():StartDownloadVersion()
    self.m_state:Transit( State.CHECK_VERSION_WAIT )
end

function DownloadView:GetDownloadVersion()
    if Inanna.GetDownloader():DownloadVersionFinish() then
        local downloadContent = Inanna.GetDownloader():GetDownloadVersionInfo() -- callback json
        local success, content = pcall(json.decode, downloadContent)
        if success then
            self.newVersion = content.version
            return true
        else
            print("Json DeSerialize fail!")
            self.m_state:Transit( State.NONE )
            return false
        end
    end
end

function DownloadView:GetLocolVersion()
    if Inanna.GetDownloader():LocalVersionIsExist() then
        local localContent = Inanna.GetDownloader():GetLocalVersionInfo() -- callback json
        local success, content = pcall(json.decode, localContent)
        if success then
            self.localVersion = content.version
            return LocalVersionState.EXIST
        else
            print("Json DeSerialize fail!")
            return LocalVersionState.ERROR
        end
    else
        return LocalVersionState.NOT_EXIST
    end
end

------------------------------------ checker ---------------------------------------- 

function DownloadView:CheckCustomVersionSame()
    if self:GetLocolVersion() == LocalVersionState.NOT_EXIST then
        Inanna.GetDownloader():StoreDownloadVersion()
        self.m_state:Transit(State.DOWNLOAD_GAME_DATA)
        Inanna.GetDownloader():StartDownloadGame()
        return
    end
    if self:GetDownloadVersion() and self:GetLocolVersion() == LocalVersionState.EXIST then
        if self.newVersion == self.localVersion then
            print("local version and download version are same")
            self.m_state:Transit(State.NONE)
            self:setVisible(false)
        else
            Inanna.GetDownloader():StartDownloadGame()
            self.m_state:Transit(State.DOWNLOAD_GAME_DATA)
        end
    end
    if self:GetLocolVersion() == LocalVersionState.ERROR then
        self.m_state:Transit(State.NONE)
    end
end

function DownloadView:DownLoadGameData()
    self:setVisible(true)
    if not Inanna.GetDownloader():DownloadGameFinish() then
        local progress = Inanna.GetDownloader():DownloadGameProgress()
        self:UpdateProgress(progress)
    else
        self:EndLoading()
        Inanna.GetDownloader():StoreDownloadVersion()
        self.m_state:Transit(State.NONE)
    end
end

function DownloadView:EndLoading()
    if self.m_LoadingBar:getPercent() == 100 then
        print("is finish")
        self:setVisible( false )
    end
end

function DownloadView:UpdateProgress(progress)
    self.m_LoadingBar:setPercent(progress)
    local loadingText = progress .. "%"
    self.m_LoadingText:setText(loadingText)
end

function DownloadView:OnEnter()
    print("DownloadView:OnEnter()")
    self:setVisible( false )
end

function DownloadView:OnExit()
    print("DownloadView:OnExit()")
end

return DownloadView