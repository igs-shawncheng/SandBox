require "app.serialization.JsonDeserialize"

local PACHIN_G2U_SPIN_ACK = class("PACHIN_G2U_SPIN_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_SPIN_ACK:ctor(content)
    self:Deserialize(content)
    -- self.SpinAck = {}
    -- self.SpinAck.bet 
    -- self.SpinAck.ackType     --SUCCESS 0
end

cc.PACHIN_G2U_SPIN_ACK = PACHIN_G2U_SPIN_ACK