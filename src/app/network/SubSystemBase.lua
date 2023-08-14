require ("app.network.NetService")
require ("app.network.Command.PACHIN_U2G_GAME_INFO_REQ")
require ("app.network.Command")
require ("app.network.Command.SLOT_G2U_GAME_INFO_ACK")

local SubSystemBase = class("SubSystemBase")
local ServerCommand = cc.Protocol.PachinG2UProtocol
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

function SubSystemBase:Send(commandType, content)
    local command = cc.Command:create(commandType, content)
    self.netService:Send(command)
end

function SubSystemBase:OnCommand(deserializeResult)
    print("SubSystemBase Recv Command:", deserializeResult.commandType)
    local recvCommand = deserializeResult.commandType
    

    if recvCommand == ServerCommand.SLOT_G2U_GAME_INFO_ACK then
        local response = cc.SLOT_G2U_GAME_INFO_ACK:create(deserializeResult.content)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.NET_LOGIN_SUCCESS )
    elseif recvCommand == ServerCommand.SLOT_G2U_SPIN_ACK then
        print("Recv Command 2")
    elseif recvCommand == ServerCommand.SLOT_G2U_FREE_SPIN_ACK then
        print("Recv Command 3")
    elseif recvCommand == ServerCommand.SLOT_G2U_BONUS_RECORD_ACK then
        print("Recv Command 4")
    elseif recvCommand == ServerCommand.SLOT_G2U_GET_BONUS_RECORD_ACK then
        print("Recv Command 5")
    end
end

cc.SubSystemBase = SubSystemBase
return SubSystemBase