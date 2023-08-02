local Protocol = class("Protocol")

local PACHIN_U2G_PROTOCOL =
{
    PACHIN_U2G_GAME_INFO_REQ				= 1,            -- 遊戲資訊要求( 押注, 桌號.... )
    PACHIN_U2G_SPIN_REQ						= 2,            -- SpinReq              押注要求
    PACHIN_U2G_SPIN_END_REQ					= 3,
    PACHIN_U2G_FREE_SPIN_REQ				= 4,
    PACHIN_U2G_FREE_SPIN_END_REQ			= 5,
    PACHIN_U2G_GET_BONUS_RECORD_REQ			= 6,            -- party 機台列表 BonusReocrdReq
}

local PACHIN_G2U_PROTOCOL =
{
    SLOT_G2U_GAME_INFO_ACK					= 1,			-- 遊戲資訊回應				GameInfoAck
    SLOT_G2U_SPIN_ACK						= 2,			-- 壓注回應					SpinAck
    SLOT_G2U_FREE_SPIN_ACK					= 3,			-- 壓注回應					SpinAck
    SLOT_G2U_BONUS_RECORD_ACK				= 4,			-- 機台專用轉速表			BonusRecord
    SLOT_G2U_GET_BONUS_RECORD_ACK			= 5,			-- std::<BonusRecord>,Uint
}

cc.Protocol = Protocol
return Protocol