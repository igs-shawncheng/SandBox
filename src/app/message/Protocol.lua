local PACHIN_U2G_PROTOCOL =
{
    PACHIN_U2G_GAME_INFO_REQ				= 1,            -- 遊戲資訊要求( 押注, 桌號.... )
    PACHIN_U2G_START_GAME_REQ               = 2,
    PACHIN_U2G_SPIN_REQ						= 3,            -- SpinReq              押注要求
    PACHIN_U2G_STOP_REEL_REQ			    = 4,            -- StopReelReq
    PACHIN_U2G_TAKE_MONEY_IN_REQ            = 5,
    PACHIN_U2G_USE_CARD_REQ                 = 6,            -- UseCardReq
    PACHIN_U2G_PLUGIN_CUSTOM_REQ            = 7,
}

local PACHIN_G2U_PROTOCOL =
{
    PACHIN_G2U_GAME_INFO_ACK				= 1,			-- GameInfoAck
    PACHIN_G2U_START_GAME_ACK               = 2,            -- StartGameAck
    PACHIN_G2U_SPIN_ACK						= 3,			-- SpinAck
    PACHIN_G2U_STOP_REEL_ACK                = 4,			-- StopReelAck			
    PACHIN_G2U_TAKE_MONEY_IN_ACK			= 5,            -- TakeMoneyAck
    PACHIN_G2U_USE_CARD_ACK                 = 6,            -- UseCardAck
    PACHIN_G2U_PLUGIN_CUSTOM_ACK            = 7,
    PACHIN_G2U_PLUGIN_CUSTOM_NOTIFY         = 8,
}

cc.Protocol = {}
cc.Protocol.PachinG2UProtocol = PACHIN_G2U_PROTOCOL
cc.Protocol.PachinU2GProtocol = PACHIN_U2G_PROTOCOL