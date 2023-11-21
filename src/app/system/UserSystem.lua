require "app.message.PACHIN_G2U_USER_INFO_ACK"
require "app.message.PACHIN_U2G_USER_INFO_REQ"

local UserSystem = class("UserSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function UserSystem:ctor()
    print("UserSystem:ctor")
    self:Registers(RecvCommand.PACHIN_G2U_USER_INFO_ACK, handler(self, self.OnRecvUserInfo))
end

function UserSystem:RequestUserInfo(accountid)
    print("Sent command 12")
    local request = cc.PACHIN_U2G_USER_INFO_REQ:create(accountid)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_USER_INFO_REQ, request:Serialize())
end

function UserSystem:OnRecvUserInfo(command)
    print("Recv command 12")
    local response = cc.PACHIN_G2U_USER_INFO_ACK:create(command.content)
    self.money = response.UserInfoAck.money
    print("User has money " .. self.money)
end

return UserSystem