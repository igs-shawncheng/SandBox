require "app.serialization.JsonSerialize"

local PACHIN_U2G_AUTO_PLAY_REQ = class("PACHIN_U2G_AUTO_PLAY_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_AUTO_PLAY_REQ:ctor()
end

cc.PACHIN_U2G_AUTO_PLAY_REQ = PACHIN_U2G_AUTO_PLAY_REQ