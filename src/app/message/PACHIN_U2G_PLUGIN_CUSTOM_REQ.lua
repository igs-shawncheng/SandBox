require "app.serialization.JsonSerialize"

local PACHIN_U2G_PLUGIN_CUSTOM_REQ = class("PACHIN_U2G_PLUGIN_CUSTOM_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_PLUGIN_CUSTOM_REQ:ctor(accountId, slotData)
    self.accountId = accountId
    self.slotData = slotData
end

cc.PACHIN_U2G_PLUGIN_CUSTOM_REQ = PACHIN_U2G_PLUGIN_CUSTOM_REQ