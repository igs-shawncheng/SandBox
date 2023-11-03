require "app.serialization.JsonDeserialize"

local PACHIN_G2U_GAME_INFO_ACK = class("PACHIN_G2U_GAME_INFO_ACK", cc.JsonDeserialize:create())

function PACHIN_G2U_GAME_INFO_ACK:ctor(content)
    self:Deserialize(content)
        -- self.GameInfoAck = {}
        -- self.GameInfoAck.bet 
        -- self.GameInfoAck.currCount
        -- self.GameInfoAck.gameMode
end

cc.PACHIN_G2U_GAME_INFO_ACK = PACHIN_G2U_GAME_INFO_ACK