require ("app.network.NetService")

local SubSystemBase = class("SubSystemBase")

function SubSystemBase:ctor()
    self:Init()
end

function SubSystemBase:GetInstance()
    if not self.instance then
        self.instance = SubSystemBase:create()
    end
    return self.instance
end

function SubSystemBase:Init()
    if self.isInit then
        return
    end
    self.isInit = true
    self.netService = cc.NetService:create(self)
end

function SubSystemBase:Login(ip, port)
    self.netService:Connect(ip, port)
end

function SubSystemBase:Send(command)
    self.netService:Send(command)
end

function SubSystemBase:OnCommand(command)
    print("SubSystemBase Recv Command:", command:CommandType())
    -- if command.commandType == commandType.SLOT_G2U_GAME_INFO_ACK then
    --     print("Recv Command 1")
    -- elseif command.commandType == commandType.SLOT_G2U_SPIN_ACK then
    --     print("Recv Command 2")
    -- elseif command.commandType == commandType.SLOT_G2U_FREE_SPIN_ACK then
    --     print("Recv Command 3")
    -- elseif command.commandType == commandType.SLOT_G2U_BONUS_RECORD_ACK then
    --     print("Recv Command 4")
    -- elseif command.commandType == commandType.SLOT_G2U_GET_BONUS_RECORD_ACK then
    --     print("Recv Command 5")
    -- end
end

cc.SubSystemBase = SubSystemBase
return SubSystemBase