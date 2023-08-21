require ("app.message.PACHIN_U2G_GAME_INFO_REQ")
require ("app.message.SLOT_G2U_GAME_INFO_ACK")

local SandBoxSystem = class("SandBoxSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function SandBoxSystem:ctor()
    print("SandBoxSystem:ctor")
    self:Registers(RecvCommand.SLOT_G2U_GAME_INFO_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_START_GAME_ACK, self.OnCommand)
    self:Registers(RecvCommand.SLOT_G2U_SPIN_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_STOP_REEL_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_TAKE_MONEY_IN_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_USE_CARD_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_U2G_PLUGIN_CUSTOM_ACK, self.OnCommand)
end

function SandBoxSystem:RequestGameInfo(accountId, roomIndex)
    local request = cc.PACHIN_U2G_GAME_INFO_REQ:create(accountId, roomIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_GAME_INFO_REQ, request:Serialize())
end

function SandBoxSystem.OnCommand(command)
    print("SandBoxSystem Recv Command:", command.commandType)
    local recvCommand = command.commandType

    if recvCommand == RecvCommand.SLOT_G2U_GAME_INFO_ACK then
        local response = cc.SLOT_G2U_GAME_INFO_ACK:create(command.content)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.NET_LOGIN_SUCCESS )
    elseif recvCommand == RecvCommand.PACHIN_G2U_START_GAME_ACK then
        print("Recv Command 2")
    elseif recvCommand == RecvCommand.SLOT_G2U_SPIN_ACK then
        print("Recv Command 3")
    elseif recvCommand == RecvCommand.PACHIN_G2U_STOP_REEL_ACK then
        print("Recv Command 4")
    elseif recvCommand == RecvCommand.PACHIN_G2U_TAKE_MONEY_IN_ACK then
        print("Recv Command 5")
    elseif recvCommand == RecvCommand.PACHIN_G2U_USE_CARD_ACK then
        print("Recv Command 6")
    elseif recvCommand == RecvCommand.PACHIN_U2G_PLUGIN_CUSTOM_ACK then
        print("Recv Command 7")
    end
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
    --cc.exports.PluginProgram:SendMessage("testSyste", "tsetCmd", "123456")
    --print("LoginVIewTest", cc.exports.PluginProgram:GetPostMessageString())
end

return SandBoxSystem