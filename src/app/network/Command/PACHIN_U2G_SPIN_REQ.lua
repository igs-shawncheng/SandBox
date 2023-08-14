require("app.network.Command.ISerialize")

local PACHIN_U2G_SPIN_REQ = class("PACHIN_U2G_SPIN_REQ", cc.ISerialize:create())

function PACHIN_U2G_SPIN_REQ:ctor(bet, useCard, cardKind)
    self.SpinReq = {}
    self.SpinReq.bet = bet
    self.SpinReq.useCard = useCard
    self.SpinReq.cardKind = cardKind
end

cc.PACHIN_U2G_SPIN_REQ = PACHIN_U2G_SPIN_REQ