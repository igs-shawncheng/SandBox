require "app.serialization.JsonSerialize"

local PACHIN_U2G_STOP_REEL_REQ = class("PACHIN_U2G_STOP_REEL_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_STOP_REEL_REQ:ctor(reelIndex)
    self.StopReelReq = {}
    self.StopReelReq.bet = reelIndex
end

cc.PACHIN_U2G_STOP_REEL_REQ = PACHIN_U2G_STOP_REEL_REQ