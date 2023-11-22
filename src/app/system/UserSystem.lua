require "app.message.PACHIN_G2U_USER_INFO_ACK"
require "app.message.PACHIN_U2G_USER_INFO_REQ"
require "app.message.PACHIN_U2G_ADD_MONEY_IN_REQ"
require "app.message.PACHIN_G2U_ADD_MONEY_IN_ACK"

local UserSystem = class("UserSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function UserSystem:ctor()
    print("UserSystem:ctor")
    self:GetInstance():Registers(RecvCommand.PACHIN_G2U_USER_INFO_ACK, handler(self, self.OnRecvUserInfo))
    self:GetInstance():Registers(RecvCommand.PACHIN_G2U_ADD_MONEY_IN_ACK, handler(self, self.OnRecvTakeMoneyIn))
end

function UserSystem:RequestUserInfo()
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_USER_INFO_REQ:create(loginSystem:GetAccount())
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_USER_INFO_REQ, request:Serialize())
end

function UserSystem:RequestMoney()
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_ADD_MONEY_IN_REQ:create(loginSystem:GetAccount())
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_ADD_MONEY_IN_REQ, request:Serialize())
end

function UserSystem:OnRecvUserInfo(command)
    local response = cc.PACHIN_G2U_USER_INFO_ACK:create(command.content)
    self.money = response.UserInfoAck.money
    print("User has money " .. self.money)
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, self.money )
end

function UserSystem:OnRecvTakeMoneyIn(command)
    local response = cc.PACHIN_G2U_ADD_MONEY_IN_ACK:create(command.content)
    self.money = self.money + response.AddMoneyAck.money
    cc.exports.dispatchEvent(cc.exports.define.PLUGIN_RESPONSE, {command.commandType, command.content})
end

function UserSystem:GetMoney()
    return self.money
end

function UserSystem:UpdateMoney(value)
    self.money = self.money - value
    return self.money
end

return UserSystem