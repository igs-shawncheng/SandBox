require "app.message.PACHIN_G2U_GAME_INFO_ACK"
require "app.message.PACHIN_G2U_START_GAME_ACK"
require "app.message.PACHIN_G2U_SPIN_ACK"
require "app.message.PACHIN_G2U_STOP_REEL_ACK"
require "app.message.PACHIN_G2U_TAKE_MONEY_IN_ACK"
require "app.message.PACHIN_G2U_USE_CARD_ACK"
require "app.message.PACHIN_U2G_LOGIN_REQ"
require "app.message.PACHIN_U2G_START_GAME_REQ"
require "app.message.PACHIN_U2G_SPIN_REQ"
require "app.message.PACHIN_U2G_STOP_REEL_REQ"
require "app.message.PACHIN_U2G_TAKE_MONEY_IN_REQ"
require "app.message.PACHIN_U2G_USE_CARD_REQ"


local SandBoxSystem = class("SandBoxSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function SandBoxSystem:ctor()
    print("SandBoxSystem:ctor")
    self:Registers(RecvCommand.PACHIN_G2U_GAME_INFO_ACK, handler(self, self.OnRecvGameInfo))
    self:Registers(RecvCommand.PACHIN_G2U_START_GAME_ACK, handler(self, self.OnRecvStartGame))
    self:Registers(RecvCommand.PACHIN_G2U_SPIN_ACK, handler(self, self.OnRecvSpin))
    self:Registers(RecvCommand.PACHIN_G2U_STOP_REEL_ACK, handler(self, self.OnRecvStopReel))
    self:Registers(RecvCommand.PACHIN_G2U_TAKE_MONEY_IN_ACK, handler(self, self.OnRecvTakeMoneyIn))
    self:Registers(RecvCommand.PACHIN_G2U_USE_CARD_ACK, handler(self, self.OnRecvUseCard))
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

function SandBoxSystem:OnRecvGameInfo(command)
    print("Recv Command 5")
    local response = cc.PACHIN_G2U_GAME_INFO_ACK:create(command.content)
    dump(response)
    --cc.exports.dispatchEvent( cc.exports.define.EVENTS.GAME_INFO_ACK, response.GameInfoAck )

    print("OnGameInfoAck",self.roomIndex)
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SET_ARCADE_NO, self.roomIndex )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, 5678 )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOINGAME )
end

function SandBoxSystem:OnRecvStartGame(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvSpin(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvStopReel(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvTakeMoneyIn(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvUseCard(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

return SandBoxSystem