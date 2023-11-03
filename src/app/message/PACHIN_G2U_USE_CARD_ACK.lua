require "app.serialization.JsonDeserialize"

local PACHIN_G2U_USE_CARD_ACK = class("PACHIN_G2U_USE_CARD_ACK", cc.JsonDeserialize:create())

local CARD_TYPE = 
{
    CARD_TYPE_NONE					= 0,
	UP_CARD							= 12001,
	FREE_SPIN_10CARD				= 12010,
	CARD_TYPE_MAX                   = 99999,
}

function PACHIN_G2U_USE_CARD_ACK:ctor(content)
    self:Deserialize(content)
    --     self.UseCardReq = {}
    --     self.UseCardReq.cardType     --SUCCESS 0, FAIL 1
end

cc.PACHIN_G2U_USE_CARD_ACK = PACHIN_G2U_USE_CARD_ACK