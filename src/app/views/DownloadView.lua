require "cocos.cocos2d.json"
local http = require("luasocket.socket.http")
local ltn12 = require("luasocket.ltn12")

local DownloadView = class("DownloadView", cc.load("mvc").ViewBase)

DownloadView.RESOURCE_FILENAME = "Platform/downloadView/DownloadView.csb"
DownloadView.RESOURCE_BINDING = {
    ["LoadingBar"] = {
        ["varname"] = "m_LoadingBar",
    },
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.DOWNLOAD,
    cc.exports.define.EVENTS.DOWNLOAD_PROGRESS,
}

local State = {
    INIT = 0,    
    DOWNLOAD_VERSION_DATA = 1,
    CHECK_VERSION_WAIT = 2,
    DOWNLOAD_GAME_DATA = 3,
    NONE = 4,
}

function DownloadView:onCreate()
    print("DownloadView:onCreate")
    self.redownloadList = {}
    self.m_state = cc.exports.FiniteState:create( State.INIT )
    self.newVersion = 0 -- download version
    self.localVersion = 0
    self:Init()
    self:RegisterEvent()
end

function DownloadView:Init()
    self.m_LoadingBar:setPercent( 0 )
    self:setVisible( false )
end

function DownloadView:RegisterEvent()
    print("DownloadView:RegisterEvent")

    local function eventHander( event )
        print("DownloadView:event", event)
        if event:getEventName() == tostring( cc.exports.define.EVENTS.DOWNLOAD ) then
            self:OnDownload()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.DOWNLOAD_PROGRESS ) then
            self:UpdateProgress(event._usedata)
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
        end,
        [State.DOWNLOAD_VERSION_DATA] = function()
            if self.m_state:IsEntering() then
                print("Download version data")
                self:DownLoadVersionData()
            end
        end,
        [State.CHECK_VERSION_WAIT] = function()
            if self.m_state:IsEntering() then
                print("check version")
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
                self:EndLoading()
            end
        end,
    })
end

function DownloadView:OnDownload()
    self:setVisible(true)
    self.m_state:Transit(State.DOWNLOAD_VERSION_DATA)
end

function DownloadView:ClearDownloadList()
    self.redownloadList = {}
end

function DownloadView:SaveVersionToLocal()
    local file = io.open(cc.exports.define.LOCAL_VERSION_DATA, "r")
    if file then
        local fileContent = file:read("*a")
        local success, content = pcall(json.decode, fileContent)
        if success then
            content.version = self.newVersion
        else
            print("Json DeSerialize fail!")
        end
        file:close()
        local success, newDataJson = pcall(json.encode, content)
        if success then
            file = io.open(cc.exports.define.LOCAL_VERSION_DATA, "w")
            if file then
                file:write(newDataJson)
                file:flush()
                file:close()
                print("Version file updated successfully.")
            else
                print("Error opening the file for writing:", file)
            end
        else
            print("Json Serialize fail!")
        end
    else
        print("Error opening the file for reading:", file)
    end
end
-- download for one file
function DownloadView:DownLoadFile(url, destination, progressCallback)
    local totalBytes = 0
    local redownload = {}
    local _, _, headers, statusCode = http.request{
        url = url,
        method = "HEAD",
    }
    local expectedSize = tonumber(headers["content-length"])
    local function downloadCallback(chunk, err)
        if chunk then
            local bytes = string.len(chunk)
            totalBytes = totalBytes + bytes

            -- download progress
            local progress = totalBytes / expectedSize * 100
            cc.exports.dispatchEvent(cc.exports.define.EVENTS.DOWNLOAD_PROGRESS, progress)
            progressCallback(url, progress)
        end
        return chunk, err
    end
    
    local _, statusCode, headers = http.request{
        url = url,
        sink = ltn12.sink.chain(downloadCallback, ltn12.sink.file(io.open(destination, "w"))),
        method = "GET",
    }

    if statusCode == 200 then
        print("DownLoad completed successfully for:", url)
    else
        print("Error during download for:", url, "HTTP Status Code:", statusCode)
        redownload["url"] = url
        redownload["destination"] = destination
        table.insert(self.redownloadList, redownload)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
        {
            title = "Error",
            content = "Error during download for: ".. url .. "HTTP Status Code: ".. statusCode,
            cancelBtnText = "I know",
            confirmBtnText = "ok",
            showCloseBtn = false,
            confirmCB = function ()
            end,
            cancelCB = function ()
            end,
        } )
    end
end

-- Start to download all files
function DownloadView:DownLoadAllFiles()
    for _, fileInfo in ipairs(cc.exports.define.DOWNLOAD_GAME_DATA) do
        local co = coroutine.create(function()
            self:DownLoadFile(fileInfo.url, fileInfo.destination, function(url, progress)
                print("DownLoad progress for", url, string.format("%.2f%%", progress))
            end)
        end)
        while coroutine.status(co) ~= "dead" do
            coroutine.resume(co)
        end
    end
end

function DownloadView:ReDownload()
    for _, fileInfo in ipairs(self.redownloadList) do
        local co = coroutine.create(function()
            self:DownLoadFile(fileInfo.url, fileInfo.destination, function(url, progress)
                print("DownLoad progress for", url, string.format("%.2f%%", progress))
                self.m_LoadingBar:setPercent(progress)
            end)
        end)

        while coroutine.status(co) ~= "dead" do
            coroutine.resume(co)
        end
    end
    self:ClearDownloadList()
end

function DownloadView:DownLoadVersionData()
    -- download new version file
    self:DownLoadFile(cc.exports.define.DOWNLOAD_VERSION_DATA.url, cc.exports.define.DOWNLOAD_VERSION_DATA.destination,
     function(url, progress)
        print("DownLoad progress for", url, string.format("%.2f%%", progress))
    end)

    local file = io.open(cc.exports.define.DOWNLOAD_VERSION_DATA.destination, "r")
    if file then
        local fileContent = file:read("*a")
        local success, content = pcall(json.decode, fileContent)
        if success then
            self.newVersion = content.version
        else
            print("Json DeSerialize fail!")
            self.m_state:Transit( State.INIT )
        end
        file:close()
    else
        print("Error opening the file:", file)
        self.m_state:Transit( State.INIT )
    end
    local localfile = io.open(cc.exports.define.LOCAL_VERSION_DATA, "r")
    if localfile then
        self.m_state:Transit( State.CHECK_VERSION_WAIT )
        localfile:close()
    else
        os.rename(cc.exports.define.DOWNLOAD_VERSION_DATA.destination, cc.exports.define.LOCAL_VERSION_DATA)
        self.m_state:Transit( State.DOWNLOAD_GAME_DATA )
    end
end

function DownloadView:GetLocolVersion()
    local file = io.open(cc.exports.define.LOCAL_VERSION_DATA, "r")
    if file then
        local fileContent = file:read("*a")
        local success, content = pcall(json.decode, fileContent)
        if success then
            self.localVersion = content.version
        else
            print("Json DeSerialize fail!")
        end
        file:close()
    else
        print("Error opening the file:", file)
    end
end

------------------------------------ checker ---------------------------------------- 

function DownloadView:CheckCustomVersionSame()
    self:GetLocolVersion()
    if self.newVersion == self.localVersion then
        print("local version and download version are same")
    else
        self.m_state:Transit(State.DOWNLOAD_GAME_DATA)
    end
end

function DownloadView:DownLoadGameData()
    self:DownLoadAllFiles()
    if #self.redownloadList ~= 0 then
        self:ReDownload()
    end
    self:SaveVersionToLocal()
    self.m_state:Transit(State.NONE)
end

function DownloadView:EndLoading()
    print("getPercent()", self.m_LoadingBar:getPercent())
    if self.m_LoadingBar:getPercent() == 100 then
        print("is finish")
        self:setVisible( false )
        self.m_LoadingBar:setPercent(0)
    end
end

function DownloadView:UpdateProgress(progress)
    self.m_LoadingBar:setPercent(progress)
end

function DownloadView:OnEnter()
    print("DownloadView:OnEnter()")
    self:setVisible( false )
end

function DownloadView:OnExit()
    print("DownloadView:OnExit()")
end

return DownloadView