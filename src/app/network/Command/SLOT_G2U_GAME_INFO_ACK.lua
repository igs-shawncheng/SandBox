require "app.network.Command.IDeserialize"
local SLOT_G2U_GAME_INFO_ACK = class("SLOT_G2U_GAME_INFO_ACK", cc.IDeserialize:create())

function SLOT_G2U_GAME_INFO_ACK:ctor(content)
    self:Deserialize(content)
    --     self.GameInfoAck = {}
    --     self.GameInfoAck.bet 
    --     self.GameInfoAck.currCount
    --     self.GameInfoAck.gameMode
    --     self.GameInfoAck.money
end

cc.SLOT_G2U_GAME_INFO_ACK = SLOT_G2U_GAME_INFO_ACK