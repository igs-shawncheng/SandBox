require "app.serialization.JsonSerialize"

local PACHIN_U2G_ROOM_INFO_REQ = class("PACHIN_U2G_ROOM_INFO_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_ROOM_INFO_REQ:ctor()
end

cc.PACHIN_U2G_ROOM_INFO_REQ = PACHIN_U2G_ROOM_INFO_REQ