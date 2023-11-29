require "app.message.PACHIN_G2U_GAME_INFO_ACK"
require "app.message.PACHIN_G2U_START_GAME_ACK"
require "app.message.PACHIN_G2U_SPIN_ACK"
require "app.message.PACHIN_G2U_STOP_REEL_ACK"

require "app.message.PACHIN_G2U_USE_CARD_ACK"
require "app.message.PACHIN_U2G_START_GAME_REQ"
require "app.message.PACHIN_U2G_SPIN_REQ"
require "app.message.PACHIN_U2G_STOP_REEL_REQ"

require "app.message.PACHIN_U2G_USE_CARD_REQ"


local SandBoxSystem = class("SandBoxSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function SandBoxSystem:ctor()
    print("SandBoxSystem:ctor")
    self:Registers(RecvCommand.PACHIN_G2U_GAME_INFO_ACK, handler(self, self.OnRecvGameInfo))
    --self:Registers(RecvCommand.PACHIN_G2U_START_GAME_ACK, handler(self, self.OnRecvStartGame))
    self:Registers(RecvCommand.PACHIN_G2U_SPIN_ACK, handler(self, self.OnRecvSpin))
    self:Registers(RecvCommand.PACHIN_G2U_STOP_REEL_ACK, handler(self, self.OnRecvStopReel))
    self:Registers(RecvCommand.PACHIN_G2U_USE_CARD_ACK, handler(self, self.OnRecvUseCard))
    self:Registers(RecvCommand.PACHIN_G2U_PLUGIN_CUSTOM_ACK, handler(self, self.OnRecvPluginCuston))
    
end

-- function SandBoxSystem:RequestStartGame()
--     self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_START_GAME_REQ)
-- end

function SandBoxSystem:RequestSpin()
    local userSystem = self:GetInstance():GetSystem(cc.exports.SystemName.UserSystem)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_SPIN_REQ:create(loginSystem:GetAccount(), self.bet)
    --todo make sure when to updateMoney, maybe more GameMode should do.
    if self.gameMode == cc.exports.define.GameMode.GameMode_Normal then
        userSystem:UpdateMoney(self.bet)
    end
    
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_SPIN_REQ, request:Serialize())
end

function SandBoxSystem:RequestStopReel(reelIndex)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_STOP_REEL_REQ:create(loginSystem:GetAccount(), reelIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_STOP_REEL_REQ, request:Serialize())
end

function SandBoxSystem:RequestUseCard(cardType)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_USE_CARD_REQ:create(loginSystem:GetAccount(), cardType)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_USE_CARD_REQ, request:Serialize())
end

function SandBoxSystem:RequestCustomMessage(content)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_PLUGIN_CUSTOM_REQ:create(loginSystem:GetAccount(), content)
    local customContent = request:Serialize()
    
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_PLUGIN_CUSTOM_REQ, customContent)
end

function SandBoxSystem:OnRecvGameInfo(command)
    print("Recv Command 5")
    local response = cc.PACHIN_G2U_GAME_INFO_ACK:create(command.content)
    dump(response)
    self.bet = response.bet
    self.currCount = response.currCount
    self.gameMode = response.gameMode
    
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOINGAME )
end

-- function SandBoxSystem:OnRecvStartGame(command)
--     cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
-- end

function SandBoxSystem:OnRecvSpin(command)
    local response = cc.PACHIN_G2U_SPIN_ACK:create(command.content)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvStopReel(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvUseCard(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function SandBoxSystem:OnRecvPluginCuston(command)
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end



return SandBoxSystem