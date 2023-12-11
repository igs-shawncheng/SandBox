require "app.serialization.JsonDeserialize"

local PACHIN_G2U_LOGIN_ACK = class("PACHIN_G2U_LOGIN_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_LOGIN_ACK:ctor(content)
    self:Deserialize(content)
    -- self.success = content.success
end

cc.PACHIN_G2U_LOGIN_ACK = PACHIN_G2U_LOGIN_ACK