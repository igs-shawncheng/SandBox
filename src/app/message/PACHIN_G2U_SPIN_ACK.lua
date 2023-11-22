require "app.serialization.JsonDeserialize"

local PACHIN_G2U_SPIN_ACK = class("PACHIN_G2U_SPIN_ACK", cc.JsonDeserialize:create())

local SpinAckType = {
	SPIN_SUCCESS		= 0,		-- 下注成功
	SPIN_MONEY_FAIL		= 1,		-- 金額錯誤
	SPIN_BET_ERROR		= 2,		-- 下注錯誤

	SPIN_NOT_INBONUS	= 3,		-- 不在BONUS中
	SPIN_NOT_MAINGAME	= 4,
	SERVER_SHUTDOWN		= 99		-- 關機中
};

function PACHIN_G2U_SPIN_ACK:ctor(content)
    self:Deserialize(content)
    -- self.SpinAck = {}
    -- self.SpinAck.bet 
    -- self.SpinAck.ackType     --SUCCESS 0
end

cc.PACHIN_G2U_SPIN_ACK = PACHIN_G2U_SPIN_ACK


