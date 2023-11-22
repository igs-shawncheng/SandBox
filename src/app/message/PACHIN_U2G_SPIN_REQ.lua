require "app.serialization.JsonSerialize"

local PACHIN_U2G_SPIN_REQ = class("PACHIN_U2G_SPIN_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_SPIN_REQ:ctor(accountId, bet)
    self.SpinReq = {}
    self.SpinReq.accountId = accountId
    self.SpinReq.bet = bet
end

cc.PACHIN_U2G_SPIN_REQ = PACHIN_U2G_SPIN_REQ