require "app.serialization.JsonSerialize"

local PACHIN_U2G_PLUGIN_CUSTOM_REQ = class("PACHIN_U2G_PLUGIN_CUSTOM_REQ", cc.JsonSerialize:create())

function PACHIN_U2G_PLUGIN_CUSTOM_REQ:ctor(accountId, content)
    self.pluginReq = {}
    self.GameInfoReq.accountId = accountId
    self.pluginReq.content = content
end

cc.PACHIN_U2G_PLUGIN_CUSTOM_REQ = PACHIN_U2G_PLUGIN_CUSTOM_REQ