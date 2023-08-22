require "app.serialization.JsonDeserialize"
local SLOT_G2U_GAME_INFO_ACK = class("SLOT_G2U_GAME_INFO_ACK", cc.JsonDeserialize:create())

function SLOT_G2U_GAME_INFO_ACK:ctor(content)
    self:Deserialize(content)
    --     self.GameInfoAck = {}
    --     self.GameInfoAck.bet 
    --     self.GameInfoAck.currCount
    --     self.GameInfoAck.gameMode
end

cc.SLOT_G2U_GAME_INFO_ACK = SLOT_G2U_GAME_INFO_ACK