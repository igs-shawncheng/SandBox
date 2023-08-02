require ("app.network.Connection")
require ("app.network.Command")
local NetSystem = class("NetSystem")
local scheduler = cc.Director:getInstance():getScheduler()
--local commandType = cc.Protocol.PACHIN_G2U_PROTOCOL
local CHECK_SELECT_INTERVAL = 0.05
local connectData = {}

local CONNECT_STATE = {
    INIT            = 1,
    WAIT_CONNECT    = 2,    -- 等待連線
    CONNECT         = 3,    -- 連線
    CONNECTING      = 4,    -- 連線中
    CONNECTED       = 5,    -- 已連線
    DISCONNECT      = 6,    -- 離線
    RECONNECT       = 7,    -- 重新連線
}

function NetSystem:GetInstance()
    if not self.instance_ then
        self.instance_ = NetSystem:new()
    end
    return self.instance_
end

function NetSystem:Init()
    print("NetSystem.INIT")
    self._connectState = cc.exports.FiniteState:create(CONNECT_STATE.INIT)
    self._schedulerID = scheduler:scheduleScriptFunc(handler(self, self.Update), CHECK_SELECT_INTERVAL, false)
end

function NetSystem:Update()
    local currentState = self._connectState:Tick()
    if currentState == CONNECT_STATE.INIT then
        if self._connectState:IsEntering() then
            self._connection = cc.Connection:new()
            self._connectState:Transit(CONNECT_STATE.WAIT_CONNECT)
            print("CONNECT_STATE.INIT")
        end
    elseif currentState == CONNECT_STATE.WAIT_CONNECT then
        if self._connectState:IsEntering() then
            print("CONNECT_STATE.WAIT_CONNECT")
        end
    elseif currentState == CONNECT_STATE.CONNECT then
        if self._connectState:IsEntering() then
            print("CONNECT_STATE.CONNECT")
            self._connection:Connect(connectData.ip, connectData.port)
            self._connectState:Transit(CONNECT_STATE.CONNECTING)
        end
    elseif currentState == CONNECT_STATE.CONNECTING then
        if self._connectState:IsEntering() then
            print("CONNECT_STATE.CONNECTING")
        end
        print("[NetSystem] => checkConnect")
        if self._connection:IsConnected() then
            self._connectState:Transit(CONNECT_STATE.CONNECTED)
        end
    elseif currentState == CONNECT_STATE.CONNECTED then
        if self._connectState:IsEntering() then
            print("CONNECT_STATE.CONNECTED")
            --dispach login event
        end
        self._connection:DisposeTCPIO()
    elseif currentState == CONNECT_STATE.DISCONNECT then
        if self._connectState:IsEntering() then
            self._connection = nil
        end
    elseif currentState == CONNECT_STATE.RECONNECT then
        if self._connectState:IsEntering() then
            self._connection = cc.Connection:new()
            self._connectState:Transit(CONNECT_STATE.CONNECT)
            print("CONNECT_STATE.RECONNECT")
        end
    end
end

function NetSystem:OnRecvSocket(buffer)
    local command = cc.Command:new()
    if command.DeSerialize(buffer) then
        print("NetSystem:DeSerialize Success command:", command.commandType)
    else
        print("NetSystem:DeSerialize Fail command:", command.commandType)
    end
end

-- function NetSystem:OnCommand(command)
    
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

function NetSystem:Connect(ip, port)
    print("[NetSystem:connect] ip, port = ", ip, port)
    connectData.ip = ip
    connectData.port = port
    self._connectState:Transit(CONNECT_STATE.CONNECT)
end

function NetSystem:Send(message)
    if self._connectState.Tick() ~= CONNECT_STATE.CONNECTED then
        return
    end
    self._connection.Send(message:Serialize())
end

function NetSystem:DisConnect()
    self._connectState:Transit(CONNECT_STATE.DISCONNECT)
end

function NetSystem:ReConnect()
    self._connectState:Transit(CONNECT_STATE.RECONNECT)
end

function NetSystem:IsConnected()
    return self._connectState.Tick() == CONNECT_STATE.CONNECTED
end


cc.NetSystem = NetSystem
return NetSystem