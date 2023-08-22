require("app.serialization.JsonSerialize")

local PACHIN_U2G_USE_CARD_REQ = class("PACHIN_U2G_USE_CARD_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_USE_CARD_REQ:ctor(cardType)
    self.UseCardReq = {}
    self.UseCardReq.cardType = cardType
end

cc.PACHIN_U2G_USE_CARD_REQ = PACHIN_U2G_USE_CARD_REQ