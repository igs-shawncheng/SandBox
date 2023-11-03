require "app.serialization.JsonDeserialize"

local PACHIN_G2U_START_GAME_ACK = class("PACHIN_G2U_START_GAME_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_START_GAME_ACK:ctor(content)
    self:Deserialize(content)
    --     self.StartGameAck = {}
    --     self.StartGameAck.money = content.money
end

cc.PACHIN_G2U_START_GAME_ACK = PACHIN_G2U_START_GAME_ACK