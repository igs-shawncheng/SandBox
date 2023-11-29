require "app.serialization.JsonSerialize"

local PACHIN_U2G_STOP_REEL_REQ = class("PACHIN_U2G_STOP_REEL_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_STOP_REEL_REQ:ctor(accountId, reelIndex)
    --reelIndex range 1-3
    self.accountId = accountId
    self.reelIndex = reelIndex
end

cc.PACHIN_U2G_STOP_REEL_REQ = PACHIN_U2G_STOP_REEL_REQ