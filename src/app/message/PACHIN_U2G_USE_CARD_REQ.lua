require "app.serialization.JsonSerialize"

local PACHIN_U2G_USE_CARD_REQ = class("PACHIN_U2G_USE_CARD_REQ", cc.JsonSerialize:create())

local CARD_TYPE = {
    CARD_TYPE_NONE					= 0,
	UP_CARD							= 12001,
	FREE_SPIN_10CARD				= 12010,
}

function PACHIN_U2G_USE_CARD_REQ:ctor(cardType)
    self.cardType = cardType
end

cc.PACHIN_U2G_USE_CARD_REQ = PACHIN_U2G_USE_CARD_REQ