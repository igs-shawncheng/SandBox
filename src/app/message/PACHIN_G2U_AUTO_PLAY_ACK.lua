require "app.serialization.JsonDeserialize"

local PACHIN_G2U_AUTO_PLAY_ACK = class("PACHIN_G2U_AUTO_PLAY_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_AUTO_PLAY_ACK:ctor(content)
    self:Deserialize(content)
end

cc.PACHIN_G2U_AUTO_PLAY_ACK = PACHIN_G2U_AUTO_PLAY_ACK