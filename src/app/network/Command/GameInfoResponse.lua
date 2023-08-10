require "cocos.cocos2d.json"
local GameInfoResponse = class("GameInfoResponse", cc.Command:create(cc.Protocol.PachinG2UProtocol.SLOT_G2U_GAME_INFO_ACK))

function GameInfoResponse:ctor(content)
    local success, data = pcall(json.decode, content)
    if success then
        self.GameInfoAck = {}
        self.GameInfoAck.bet = data.GameInfoAck.bet
        self.GameInfoAck.currCount = data.GameInfoAck.currCount
        self.GameInfoAck.gameMode = data.GameInfoAck.gameMode
        self.GameInfoAck.money = data.GameInfoAck.money
    else
        print("GameInfoResponse:json DeSerialize fail!", content)
    end
end

cc.GameInfoResponse = GameInfoResponse
return GameInfoResponse