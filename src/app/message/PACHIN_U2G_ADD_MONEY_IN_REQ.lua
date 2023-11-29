require "app.serialization.JsonSerialize"

local PACHIN_U2G_ADD_MONEY_IN_REQ = class("PACHIN_U2G_ADD_MONEY_IN_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_ADD_MONEY_IN_REQ:ctor(accountId)
    self.accountId = accountId
end

cc.PACHIN_U2G_ADD_MONEY_IN_REQ = PACHIN_U2G_ADD_MONEY_IN_REQ