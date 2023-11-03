require "app.message.PACHIN_G2U_LOGIN_ACK"
require "app.message.PACHIN_G2U_ROOM_INFO_ACK"
require "app.message.PACHIN_G2U_JOIN_ROOM_ACK"
require "app.message.PACHIN_G2U_GAME_INFO_ACK"
require "app.message.PACHIN_G2U_START_GAME_ACK"
require "app.message.PACHIN_G2U_SPIN_ACK"
require "app.message.PACHIN_G2U_STOP_REEL_ACK"
require "app.message.PACHIN_G2U_TAKE_MONEY_IN_ACK"
require "app.message.PACHIN_G2U_USE_CARD_ACK"
require "app.message.PACHIN_U2G_LOGIN_REQ"
require "app.message.PACHIN_U2G_ROOM_INFO_REQ"
require "app.message.PACHIN_U2G_JOIN_ROOM_REQ"
require "app.message.PACHIN_U2G_LEAVE_ROOM_REQ"
require "app.message.PACHIN_U2G_GAME_INFO_REQ"
require "app.message.PACHIN_U2G_START_GAME_REQ"
require "app.message.PACHIN_U2G_SPIN_REQ"
require "app.message.PACHIN_U2G_STOP_REEL_REQ"
require "app.message.PACHIN_U2G_TAKE_MONEY_IN_REQ"
require "app.message.PACHIN_U2G_USE_CARD_REQ"


local SandBoxSystem = class("SandBoxSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function SandBoxSystem:ctor()
    print("SandBoxSystem:ctor")
    self:Registers(RecvCommand.PACHIN_G2U_LOGIN_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_ROOM_INFO_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_JOIN_ROOM_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_GAME_INFO_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_START_GAME_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_SPIN_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_STOP_REEL_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_TAKE_MONEY_IN_ACK, self.OnCommand)
    self:Registers(RecvCommand.PACHIN_G2U_USE_CARD_ACK, self.OnCommand)
end

function SandBoxSystem:RequestLogin(accountid)
    local request = cc.PACHIN_U2G_LOGIN_REQ:create(accountid)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_LOGIN_REQ, request:Serialize())
end

function SandBoxSystem:RequestRoomInfo(accountid)
    local request = cc.PACHIN_U2G_ROOM_INFO_REQ:create(accountid)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_ROOM_INFO_REQ, request:Serialize())
end

function SandBoxSystem:RequestJoinRoom(accountId,roomIndex)
    local request = cc.PACHIN_U2G_JOIN_ROOM_REQ:create(accountId,roomIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_JOIN_ROOM_REQ, request:Serialize())
end

function SandBoxSystem:RequestLeaveRoom(accountid,reserve)
    local request = cc.PACHIN_U2G_LEAVE_ROOM_REQ:create(accountid,reserve)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_LEAVE_ROOM_REQ, request:Serialize())
end

function SandBoxSystem:RequestGameInfo(accountId, roomIndex)
    local request = cc.PACHIN_U2G_GAME_INFO_REQ:create(accountId, roomIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_GAME_INFO_REQ, request:Serialize())
end

function SandBoxSystem:RequestStartGame()
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_START_GAME_REQ)
end

function SandBoxSystem:RequestSpin(bet)
    local request = cc.PACHIN_U2G_SPIN_REQ:create(bet)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_SPIN_REQ, request)
end

function SandBoxSystem:RequestStopReel(reelIndex)
    local request = cc.PACHIN_U2G_STOP_REEL_REQ:create(reelIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_STOP_REEL_REQ, request)
end

function SandBoxSystem:RequestMoney()
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_TAKE_MONEY_IN_REQ)
end

function SandBoxSystem:RequestUseCard(cardType)
    local request = cc.PACHIN_U2G_USE_CARD_REQ:create(cardType)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_USE_CARD_REQ, request)
end

function SandBoxSystem.OnCommand(command)
    print("SandBoxSystem Recv Command:", command.commandType)

    local recvCommand = command.commandType

    if recvCommand == RecvCommand.PACHIN_G2U_LOGIN_ACK then
        print("Recv Command 1")
        local response = cc.PACHIN_G2U_LOGIN_ACK:create(command.content)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.LOGIN_SUCCESS, response.LoginAck )
    elseif recvCommand == RecvCommand.PACHIN_G2U_ROOM_INFO_ACK then 
        print("Recv Command 2")
        local response = cc.PACHIN_G2U_ROOM_INFO_ACK:create(command.content)
        dump(response)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.ROOM_INFO_ACK, response.RoomInfoAck )
    elseif recvCommand == RecvCommand.PACHIN_G2U_JOIN_ROOM_ACK then
        print("Recv Command 3")
        local response = cc.PACHIN_G2U_JOIN_ROOM_ACK:create(command.content)
        dump(response)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOIN_ROOM_ACK, response.JoinRoomAck )
    elseif recvCommand == RecvCommand.PACHIN_G2U_GAME_INFO_ACK then
        print("Recv Command 5")
        local response = cc.PACHIN_G2U_GAME_INFO_ACK:create(command.content)
        dump(response)
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.GAME_INFO_ACK, response.GameInfoAck )
    elseif recvCommand == RecvCommand.PACHIN_G2U_START_GAME_ACK then
        print("Recv Command 6")
    elseif recvCommand == RecvCommand.PACHIN_G2U_SPIN_ACK then
        print("Recv Command 7")
    elseif recvCommand == RecvCommand.PACHIN_G2U_STOP_REEL_ACK then
        print("Recv Command 8")
    elseif recvCommand == RecvCommand.PACHIN_G2U_TAKE_MONEY_IN_ACK then
        print("Recv Command 9")
    elseif recvCommand == RecvCommand.PACHIN_G2U_USE_CARD_ACK then
        print("Recv Command 10")
    end

    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
    --cc.exports.PluginProgram:SendMessage("testSyste", "tsetCmd", "123456")
    --print("LoginVIewTest", cc.exports.PluginProgram:GetPostMessageString())
end

return SandBoxSystem