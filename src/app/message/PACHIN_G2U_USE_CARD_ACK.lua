require "app.serialization.JsonDeserialize"

local PACHIN_G2U_USE_CARD_ACK = class("PACHIN_G2U_USE_CARD_ACK", cc.JsonDeserialize:create())

local UseCardAckType = 
{
    USE_CARD_SUCCESS					= 0, --success
	USE_CARD_FAIL						= 1, --fail
}

function PACHIN_G2U_USE_CARD_ACK:ctor(content)
    self:Deserialize(content)
    --     self.ackType
end

cc.PACHIN_G2U_USE_CARD_ACK = PACHIN_G2U_USE_CARD_ACK