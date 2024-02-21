require "app.message.PACHIN_G2U_GAME_INFO_ACK"
require "app.message.PACHIN_G2U_START_GAME_ACK"
require "app.message.PACHIN_G2U_SPIN_ACK"
require "app.message.PACHIN_G2U_STOP_REEL_ACK"

require "app.message.PACHIN_G2U_USE_CARD_ACK"
require "app.message.PACHIN_U2G_START_GAME_REQ"
require "app.message.PACHIN_U2G_SPIN_REQ"
require "app.message.PACHIN_U2G_STOP_REEL_REQ"

require "app.message.PACHIN_U2G_USE_CARD_REQ"

require "app.message.PACHIN_G2U_AUTO_PLAY_ACK"
require "app.message.PACHIN_U2G_AUTO_PLAY_REQ"

local SandBoxSystem = class("SandBoxSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function SandBoxSystem:ctor()
    print("SandBoxSystem:ctor")
    self:Registers(RecvCommand.PACHIN_G2U_GAME_INFO_ACK, handler(self, self.OnRecvGameInfo))
    self:Registers(RecvCommand.PACHIN_G2U_START_GAME_ACK, handler(self, self.OnRecvStartGame))
    self:Registers(RecvCommand.PACHIN_G2U_SPIN_ACK, handler(self, self.OnRecvSpin))
    self:Registers(RecvCommand.PACHIN_G2U_STOP_REEL_ACK, handler(self, self.OnRecvStopReel))
    self:Registers(RecvCommand.PACHIN_G2U_USE_CARD_ACK, handler(self, self.OnRecvUseCard))
    self:Registers(RecvCommand.PACHIN_G2U_PLUGIN_CUSTOM_ACK, handler(self, self.OnRecvPluginCuston))
    self:Registers(RecvCommand.PACHIN_G2U_AUTO_PLAY_ACK, handler(self, self.OnRecvAutoPlay))
    self.bet = 0
    
end

function SandBoxSystem:RequestStartGame()
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_START_GAME_REQ)
end

function SandBoxSystem:RequestSpin(slotData)
    local userSystem = self:GetInstance():GetSystem(cc.exports.SystemName.UserSystem)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_SPIN_REQ:create(self.bet, slotData)
    --todo make sure when to updateMoney, maybe more GameMode should do.
    if self.gameMode == cc.exports.define.GameMode.GameMode_Normal then
        userSystem:UpdateMoney(self.bet)
    end
    
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_SPIN_REQ, request:Serialize())
end

function SandBoxSystem:RequestStopReel(slotData)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_STOP_REEL_REQ:create(slotData)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_STOP_REEL_REQ, request:Serialize())
end

function SandBoxSystem:RequestUseCard(cardType)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_USE_CARD_REQ:create(cardType)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_USE_CARD_REQ, request:Serialize())
end

function SandBoxSystem:RequestCustomMessage(slotData)
    local request = cc.PACHIN_U2G_PLUGIN_CUSTOM_REQ:create(slotData)
    local customReq = request:Serialize()
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_PLUGIN_CUSTOM_REQ, customReq)
end

function SandBoxSystem:RequestAutoPlay()
    local request = cc.PACHIN_U2G_AUTO_PLAY_REQ:create()
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_AUTO_PLAY_REQ, request.Serialize())
end

function SandBoxSystem:OnRecvGameInfo(command)
    print("Recv Command 5")
    local response = cc.PACHIN_G2U_GAME_INFO_ACK:create(command.content)
    dump(response)
    self.bet = response.bet
    self.currCount = response.currCount
    self.gameMode = response.gameMode
    
    --cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOINGAME )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.PLUGIN_RESPONSE, {command.commandType, command.content} )
end

function SandBoxSystem:OnRecvStartGame(command)
    cc.exports.dispatchEvent(cc.exports.define.EVENTS.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvSpin(command)
    cc.exports.dispatchEvent(cc.exports.define.EVENTS.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvStopReel(command)
    cc.exports.dispatchEvent(cc.exports.define.EVENTS.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvUseCard(command)
    cc.exports.dispatchEvent(cc.exports.define.EVENTS.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvPluginCuston(command)
    cc.exports.dispatchEvent(cc.exports.define.EVENTS.PLUGIN_RESPONSE, {command.commandType, command.slotData})
end

function SandBoxSystem:OnRecvAutoPlay(command)
    cc.exports.dispatchEvent(cc.exports.define.EVENTS.PLUGIN_RESPONSE, {command.commandType, command.content})
end


return SandBoxSystem