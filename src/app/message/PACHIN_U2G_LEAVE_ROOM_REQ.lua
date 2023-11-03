require "app.serialization.JsonSerialize"

local PACHIN_U2G_LEAVE_ROOM_REQ = class("PACHIN_U2G_LEAVE_ROOM_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_LEAVE_ROOM_REQ:ctor(accountId,reserve)
    self.LeaveRoomReq = {}
    self.LeaveRoomReq.accountId = accountId
    self.LeaveRoomReq.reserve = reserve
end

cc.PACHIN_U2G_LEAVE_ROOM_REQ = PACHIN_U2G_LEAVE_ROOM_REQ