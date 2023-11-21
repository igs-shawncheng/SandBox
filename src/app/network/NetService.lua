require ("app.network.Connection")
require ("app.network.Processor.ResponseTrackerProcessor")
require ("app.message.CommandRecv")
require ("app.message.CommandSend")

local NetService = class("NetService")
local scheduler = cc.Director:getInstance():getScheduler()
local CHECK_SELECT_INTERVAL = 0.02
local CommandProcessor = {}

local CONNECT_STATE = {
    WAIT_CONNECT    = 1,    -- 等待連線
    CONNECT         = 2,    -- 連線
    CONNECTING      = 3,    -- 連線中
    CONNECTED       = 4,    -- 已連線
    DISCONNECT      = 5,    -- 離線
    RECONNECT       = 6,    -- 重新連線
}

function NetService:ctor(subSystemBase)
    self:Init(subSystemBase)
end

function NetService:Init(subSystemBase)
    self.subSystemBase = subSystemBase
    self.loginState = cc.exports.FiniteState:create(CONNECT_STATE.WAIT_CONNECT)
    self.connectData = {}
    self.connection = cc.Connection:create(
        function (buffer)
            self:OnRecvSocket(buffer)
        end)
    self._schedulerID = scheduler:scheduleScriptFunc(handler(self, self.Update), CHECK_SELECT_INTERVAL, false)
    table.insert(CommandProcessor, cc.ResponseTrackerProcessor.create())
end

function NetService:Connect(ip, port, connectedCallback)
    print("NetService:connect ip, port = ", ip, port)
    self.connectData.ip = ip
    self.connectData.port = port
    self.connectedCallback = connectedCallback
    self.loginState:Transit(CONNECT_STATE.CONNECT)
end

function NetService:Update()
    local currentState = self.loginState:Tick()
    if currentState == CONNECT_STATE.WAIT_CONNECT then
        if self.loginState:IsEntering() then
        end
    elseif currentState == CONNECT_STATE.CONNECT then
        if self.loginState:IsEntering() then
            print("NetService.CONNECT")
            self.connection:Connect(self.connectData.ip, self.connectData.port)
            self.loginState:Transit(CONNECT_STATE.CONNECTING)
        end
    elseif currentState == CONNECT_STATE.CONNECTING then
        if self.loginState:IsEntering() then
            print("NetService.CONNECTING")
        end
        --todo connect timeout
        if self.connection:IsConnected() then
            self.loginState:Transit(CONNECT_STATE.CONNECTED)
        end
    elseif currentState == CONNECT_STATE.CONNECTED then
        if self.loginState:IsEntering() then
            print("NetService:Connect Success.")
            self.connectedCallback()
        end
        self.connection:HandleSocketIOLoop()
    elseif currentState == CONNECT_STATE.DISCONNECT then
        if self.loginState:IsEntering() then
            self.connection:Close()
            print("NetService:DISCONNECT.")
        end
    elseif currentState == CONNECT_STATE.RECONNECT then
        if self.loginState:IsEntering() then
            self.loginState:Transit(CONNECT_STATE.CONNECT)
            print("NetService.RECONNECT")
        end
    end
end

function NetService:OnRecvSocket(buffer)
    local deCommand = cc.CommandRecv:create(buffer)

    for key, value in pairs(CommandProcessor) do
        value:PreProcessRecv(deCommand.commandType, deCommand.content)
    end

    if self.subSystemBase then
        self.subSystemBase:OnCommand(deCommand)
    end
end

function NetService:Send(commandType, content)
    local command = cc.CommandSend:create(commandType, content)
    if self.loginState:Tick() ~= CONNECT_STATE.CONNECTED then
        print("Send Command [".. command.commandType .. "] Fail! Connection doesn't Connected.")
        return
    end
    
    for key, value in pairs(CommandProcessor) do
        value:PreProcessSend(command.commandType, command.content)
    end

    self.connection:Send(command:Serialize())
end

function NetService:DisConnect()
    self.loginState:Transit(CONNECT_STATE.DISCONNECT)
end

function NetService:ReConnect()
    self.loginState:Transit(CONNECT_STATE.RECONNECT)
end

function NetService:IsConnected()
    if self.loginState == nil then
        return false
    end
    return self.loginState:Tick() == CONNECT_STATE.CONNECTED
end


cc.NetService = NetService
return NetService