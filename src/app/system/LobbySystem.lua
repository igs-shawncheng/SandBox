require "app.message.PACHIN_G2U_ROOM_INFO_ACK"
require "app.message.PACHIN_G2U_JOIN_ROOM_ACK"
require "app.message.PACHIN_U2G_ROOM_INFO_REQ"
require "app.message.PACHIN_U2G_JOIN_ROOM_REQ"
require "app.message.PACHIN_U2G_LEAVE_ROOM_REQ"
require "app.message.PACHIN_U2G_GAME_INFO_REQ"

local LobbySystem = class("LobbySystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function LobbySystem:ctor()
    print("LobbySystem:ctor")
    self:Registers(RecvCommand.PACHIN_G2U_ROOM_INFO_ACK, handler(self, self.OnRecvRoomInfo))
    self:Registers(RecvCommand.PACHIN_G2U_JOIN_ROOM_ACK, handler(self, self.OnRecvJoinRoom)) 
end

function LobbySystem:RequestRoomInfo()
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_ROOM_INFO_REQ:create(loginSystem:GetAccount())
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_ROOM_INFO_REQ, request:Serialize())
end

function LobbySystem:RequestJoinRoom(roomIndex)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    self.roomIndex = loginSystem:GetDefaultorTextValue(DEFAULT_LOGIN_INFO.roomIndex, roomIndex)
    print("Room NO:",  self.roomIndex)

    local reserveRoomIndex = self.roomInfo.roomIndex
    --新進入的機台與保留機台不一樣
    if self.roomInfo.reserve == true and self.roomIndex ~= reserveRoomIndex then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
        {
            title = "SystemInfo",
            content = "reserveRoomNumber: " .. reserveRoomIndex,
            confirmBtnText = "Enter Reserve Room",
            cancelBtnText = "Enter New Room",
            showCloseBtn = true,
            confirmCB = function ()
                print("click confirmCB",reserveRoomIndex)
                self.roomIndex = reserveRoomIndex
                self:RequestJoinRoom(reserveRoomIndex)
            end,
            cancelCB = function ()
                print("click cancelCB",self.roomIndex)
                self:RequestJoinRoom(self.roomIndex)
            end,
            closeCB = function ()
                print("click closeCB")
            end,
        } )
        return
    end
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_JOIN_ROOM_REQ:create(loginSystem:GetAccount(), self.roomIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_JOIN_ROOM_REQ, request:Serialize())
end

function LobbySystem:RequestGameInfo(roomIndex)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_GAME_INFO_REQ:create(loginSystem:GetAccount(), roomIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_GAME_INFO_REQ, request:Serialize())
end

function LobbySystem:RequestLeaveRoom(reserve)
    local loginSystem = self:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    local request = cc.PACHIN_U2G_LEAVE_ROOM_REQ:create(loginSystem:GetAccount(), reserve)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_LEAVE_ROOM_REQ, request:Serialize())
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.LEAVEGAME )
end

function LobbySystem:OnRecvRoomInfo(command)
    print("LobbySystem:OnRecvRoomInfo")
    local response = cc.PACHIN_G2U_ROOM_INFO_ACK:create(command.content)
    dump(response)
    self.roomInfo = response.RoomInfoAck

    local userSystem = self:GetInstance():GetSystem(cc.exports.SystemName.UserSystem)
    userSystem:RequestUserInfo()
end

function LobbySystem:OnRecvJoinRoom(command)
    print("LobbySystem:OnRecvJoinRoom")
    local response = cc.PACHIN_G2U_JOIN_ROOM_ACK:create(command.content)
    dump(response)
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOINGAME, response.JoinRoomAck )

    if response.JoinRoomAck.success then
        self:RequestGameInfo(self.roomIndex)
    else
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
        {
            title = "SystemInfo",
            content = "JoinRoomFail",
            confirmCB = function ()
            print("click confirmCB")
        end,
            btnPosType = 1,
        } )
    end
end

return LobbySystem