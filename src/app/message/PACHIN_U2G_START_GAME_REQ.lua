require "app.serialization.JsonSerialize"

local PACHIN_U2G_START_GAME_REQ = class("PACHIN_U2G_START_GAME_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_START_GAME_REQ:ctor()
end

cc.PACHIN_U2G_START_GAME_REQ = PACHIN_U2G_START_GAME_REQ