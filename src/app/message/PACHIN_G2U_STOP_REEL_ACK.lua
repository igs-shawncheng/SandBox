require "app.serialization.JsonDeserialize"

local PACHIN_G2U_STOP_REEL_ACK = class("PACHIN_G2U_STOP_REEL_ACK", cc.JsonDeserialize:create())

local StopReelAckType = {
	STOP_REEL_SUCCESS		= 0,	-- 成功
	STOP_REEL_FAIL		= 1,		-- 錯誤
};

function PACHIN_G2U_STOP_REEL_ACK:ctor(content)
    self:Deserialize(content)
    --     self.StopReelAck = {}
    --     self.StopReelAck.ackType = content.ackType --SUCCESS 0, FAIL 1
end

cc.PACHIN_G2U_STOP_REEL_ACK = PACHIN_G2U_STOP_REEL_ACK