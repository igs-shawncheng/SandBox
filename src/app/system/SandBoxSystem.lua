require ("app.network.NetService")
require ("app.message.PACHIN_U2G_GAME_INFO_REQ")
require ("app.message.SLOT_G2U_GAME_INFO_ACK")

local SandBoxSystem = class("SandBoxSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function SandBoxSystem:ctor()
    self:Registers(RecvCommand.SLOT_G2U_GAME_INFO_ACK, self.OnCommand)
    self:Registers(RecvCommand.SLOT_G2U_BONUS_RECORD_NOTIFY, self.OnCommand)
end

function SandBoxSystem:Send(commandType, content)
    --SandBoxSystem implement
    self:GetInstance():Send(commandType, content)--call subSystem Send
end

function SandBoxSystem.OnCommand(command)
    print("SandBoxSystem Recv Command:", command.commandType)
    local recvCommand = command.commandType

    if recvCommand == RecvCommand.SLOT_G2U_GAME_INFO_ACK then
        local response = cc.SLOT_G2U_GAME_INFO_ACK:create(command.content)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.NET_LOGIN_SUCCESS )
    elseif recvCommand == RecvCommand.SLOT_G2U_SPIN_ACK then
        print("Recv Command 2")
    elseif recvCommand == RecvCommand.SLOT_G2U_BONUS_SPIN_ACK then
        print("Recv Command 4")
    elseif recvCommand == RecvCommand.SLOT_G2U_GET_BONUS_RECORD_ACK then
        print("Recv Command 6")
    elseif recvCommand == RecvCommand.SLOT_G2U_BONUS_RECORD_NOTIFY then
        print("Recv Command 7")
    end
    --cc.exports.PluginProgram:SendMessage("testSyste", "tsetCmd", "123456")
    --print("LoginVIewTest", cc.exports.PluginProgram:GetPostMessageString())
end

cc.SandBoxSystem = SandBoxSystem
return SandBoxSystem