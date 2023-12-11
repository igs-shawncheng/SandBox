require "app.serialization.JsonDeserialize"

local PACHIN_G2U_PLUGIN_CUSTOM_ACK = class("PACHIN_G2U_PLUGIN_CUSTOM_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_PLUGIN_CUSTOM_ACK:ctor(slotData)
    self:Deserialize(slotData)
    -- self.slotData
end

cc.PACHIN_G2U_PLUGIN_CUSTOM_ACK = PACHIN_G2U_PLUGIN_CUSTOM_ACK