local PACHIN_U2G_PROTOCOL =
{
    PACHIN_U2G_GAME_INFO_REQ				= 1,            -- 遊戲資訊要求( 押注, 桌號.... )
    PACHIN_U2G_SPIN_REQ						= 2,            -- SpinReq              押注要求
    PACHIN_U2G_SPIN_END_REQ					= 3,
    PACHIN_U2G_BONUS_SPIN_REQ				= 4,
    PACHIN_U2G_BONUS_SPIN_END_REQ			= 5,
    PACHIN_U2G_GET_BONUS_RECORD_REQ			= 6,            -- party 機台列表
}

local PACHIN_G2U_PROTOCOL =
{
    SLOT_G2U_GAME_INFO_ACK					= 1,			-- 遊戲資訊回應				GameInfoAck
    SLOT_G2U_SPIN_ACK						= 2,			-- 壓注回應					SpinAck
    --SLOT_G2U_SPIN_END_ACK					= 3,		
    SLOT_G2U_BONUS_SPIN_ACK                 = 4,			-- 壓注回應					SpinAck
    --SLOT_G2U_BONUS_SPIN_END_ACK             = 5,
    SLOT_G2U_GET_BONUS_RECORD_ACK			= 6,
    SLOT_G2U_BONUS_RECORD_NOTIFY            = 7,            -- 機台專用轉速表			BonusRecord
}

cc.Protocol = {}
cc.Protocol.PachinG2UProtocol = PACHIN_G2U_PROTOCOL
cc.Protocol.PachinU2GProtocol = PACHIN_U2G_PROTOCOL