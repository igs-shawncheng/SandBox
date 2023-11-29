require "app.serialization.JsonSerialize"

local PACHIN_U2G_USER_INFO_REQ = class("PACHIN_U2G_USER_INFO", cc.JsonSerialize:create())

function PACHIN_U2G_USER_INFO_REQ:ctor(accountId)
    self.accountId = accountId
end

cc.PACHIN_U2G_USER_INFO_REQ = PACHIN_U2G_USER_INFO_REQ