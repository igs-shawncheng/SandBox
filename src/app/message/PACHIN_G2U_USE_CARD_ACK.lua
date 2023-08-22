require "app.serialization.JsonDeserialize"
local SLOT_G2U_GAME_INFO_ACK = class("SLOT_G2U_GAME_INFO_ACK", cc.JsonDeserialize:create())

local CARD_TYPE =
{
    CARD_TYPE_NONE					= 0,
	UP_CARD							= 12001,
	FREE_SPIN_10CARD				= 12010,
	CARD_TYPE_MAX                   = 99999,
}

function SLOT_G2U_GAME_INFO_ACK:ctor(content)
    self:Deserialize(content)
    --     self.UseCardReq = {}
    --     self.UseCardReq.cardType     --SUCCESS 0, FAIL 1
end

cc.SLOT_G2U_GAME_INFO_ACK = SLOT_G2U_GAME_INFO_ACK