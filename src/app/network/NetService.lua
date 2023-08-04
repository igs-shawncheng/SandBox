require ("app.network.Connection")
require ("app.network.Command")
require ("app.network.Protocol")

local NetService = class("NetService")
local scheduler = cc.Director:getInstance():getScheduler()
--local commandType = cc.Protocol.PACHIN_G2U_PROTOCOL
local CHECK_SELECT_INTERVAL = 0.05

local CONNECT_STATE = {
    INIT            = 1,
    WAIT_CONNECT    = 2,    -- 等待連線
    CONNECT         = 3,    -- 連線
    CONNECTING      = 4,    -- 連線中
    CONNECTED       = 5,    -- 已連線
    DISCONNECT      = 6,    -- 離線
    RECONNECT       = 7,    -- 重新連線
}

function NetService:ctor()
    self:Init()
end

function NetService:GetInstance()
    if not self.instance_ then
        self.instance_ = NetService:create()
    end
    return self.instance_
end

function NetService:Init()
    self._loginState = cc.exports.FiniteState:create(CONNECT_STATE.INIT)
    self._schedulerID = scheduler:scheduleScriptFunc(handler(self, self.Update), CHECK_SELECT_INTERVAL, false)
end

function NetService:Update()
    local currentState = self._loginState:Tick()
    if currentState == CONNECT_STATE.INIT then
        if self._loginState:IsEntering() then
            self._connection = cc.Connection.create(self.OnRecvSocket)
            self._connectData = {}
            self._loginState:Transit(CONNECT_STATE.WAIT_CONNECT)
        end
    elseif currentState == CONNECT_STATE.WAIT_CONNECT then
        if self._loginState:IsEntering() then
            print("LOGIN_STATE.WAIT_CONNECT")
        end
    elseif currentState == CONNECT_STATE.CONNECT then
        if self._loginState:IsEntering() then
            print("LOGIN_STATE.CONNECT")
            self._connection:Connect(self._connectData.ip, self._connectData.port)
            self._loginState:Transit(CONNECT_STATE.CONNECTING)
        end
    elseif currentState == CONNECT_STATE.CONNECTING then
        if self._loginState:IsEntering() then
            print("LOGIN_STATE.CONNECTING")
        end
        --todo connect timeout
        if self._connection:IsConnected() then
            self._loginState:Transit(CONNECT_STATE.CONNECTED)
        end
    elseif currentState == CONNECT_STATE.CONNECTED then
        if self._loginState:IsEntering() then
            print("LOGIN_STATE.CONNECTED")
            cc.exports.dispatchEvent( cc.exports.define.EVENTS.NET_LOGIN_SUCCESS )
        end
        self._connection:HandleSocketIOLoop()
    elseif currentState == CONNECT_STATE.DISCONNECT then
        if self._loginState:IsEntering() then
            self._connection = nil
        end
    elseif currentState == CONNECT_STATE.RECONNECT then
        if self._loginState:IsEntering() then
            self._connection = cc.Connection:create(self.OnRecvSocket)
            self._loginState:Transit(CONNECT_STATE.CONNECT)
            print("LOGIN_STATE.RECONNECT")
        end
    end
end

function NetService:OnRecvSocket(buffer)
    local command = cc.Command:create()
    if command.DeSerialize(buffer) then
        print("NetService:DeSerialize Success command:", command.commandType)
    else
        print("NetService:DeSerialize Fail command:", command.commandType)
    end
end

-- function NetService:OnCommand(command)
    
--     if command.commandType == commandType.SLOT_G2U_GAME_INFO_ACK then
--         print("Recv Command 1")
--     elseif command.commandType == commandType.SLOT_G2U_SPIN_ACK then
--         print("Recv Command 2")
--     elseif command.commandType == commandType.SLOT_G2U_FREE_SPIN_ACK then
--         print("Recv Command 3")
--     elseif command.commandType == commandType.SLOT_G2U_BONUS_RECORD_ACK then
--         print("Recv Command 4")
--     elseif command.commandType == commandType.SLOT_G2U_GET_BONUS_RECORD_ACK then
--         print("Recv Command 5")
--     end
-- end

function NetService:Connect(ip, port)
    print("[NetService:connect] ip, port = ", ip, port)
    self._connectData.ip = ip
    self._connectData.port = port
    self._loginState:Transit(CONNECT_STATE.CONNECT)
end

function NetService:Send(command)
    if self._loginState:Tick() ~= CONNECT_STATE.CONNECTED then
        return
    end
    self._connection:Send(command:Serialize())
end

function NetService:DisConnect()
    self._loginState:Transit(CONNECT_STATE.DISCONNECT)
end

function NetService:ReConnect()
    self._loginState:Transit(CONNECT_STATE.RECONNECT)
end

function NetService:IsConnected()
    if self._loginState == nil then
        return false
    end
    return self._loginState:Tick() == CONNECT_STATE.CONNECTED
end


cc.NetService = NetService
return NetService