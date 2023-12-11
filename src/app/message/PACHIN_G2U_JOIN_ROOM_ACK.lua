require "app.serialization.JsonDeserialize"

local PACHIN_G2U_JOIN_ROOM_ACK = class("PACHIN_G2U_JOIN_ROOM_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_JOIN_ROOM_ACK:ctor(content)
    self:Deserialize(content)
    -- self.success = success
end

cc.PACHIN_G2U_JOIN_ROOM_ACK = PACHIN_G2U_JOIN_ROOM_ACK