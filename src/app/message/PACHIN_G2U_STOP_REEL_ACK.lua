require "app.serialization.JsonDeserialize"
local PACHIN_G2U_STOP_REEL_ACK = class("PACHIN_G2U_STOP_REEL_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_STOP_REEL_ACK:ctor(content)
    self:Deserialize(content)
    --     self.StopReelAck = {}
    --     self.StopReelAck.ackType --SUCCESS 0, FAIL 1
end

cc.PACHIN_G2U_STOP_REEL_ACK = PACHIN_G2U_STOP_REEL_ACK