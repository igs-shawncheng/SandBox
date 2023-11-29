local PACHIN_U2G_PROTOCOL =
{
    PACHIN_U2G_LOGIN_REQ                    = 1,            -- 要求登入
    PACHIN_U2G_ROOM_INFO_REQ                = 2,            -- 要求房間資訊 (是否有保留機台)
    PACHIN_U2G_JOIN_ROOM_REQ                = 3,            -- 要求加入遊戲
    PACHIN_U2G_LEAVE_ROOM_REQ               = 4,            -- 要求離開房間
    PACHIN_U2G_GAME_INFO_REQ				= 5,            -- 遊戲資訊要求( 押注, 桌號.... )
    PACHIN_U2G_START_GAME_REQ               = 6,            -- StartGame
    PACHIN_U2G_SPIN_REQ						= 7,            -- Spin  押注要求
    PACHIN_U2G_STOP_REEL_REQ			    = 8,            -- StopReel
    PACHIN_U2G_ADD_MONEY_IN_REQ             = 9,            -- AddMoneyIn
    PACHIN_U2G_USE_CARD_REQ                 = 10,           -- UseCard
    PACHIN_U2G_PLUGIN_CUSTOM_REQ            = 11,           -- PluginCustom
    PACHIN_U2G_USER_INFO_REQ                = 12,           -- UserInfoReq
}

local PACHIN_G2U_PROTOCOL =
{
    PACHIN_G2U_LOGIN_ACK                    = 1,            -- 登入成功
    PACHIN_G2U_ROOM_INFO_ACK                = 2,            -- RoomInfo
    PACHIN_G2U_JOIN_ROOM_ACK                = 3,            -- 回應加入遊戲
    PACHIN_G2U_GAME_INFO_ACK				= 5,			-- GameInfo
    PACHIN_G2U_START_GAME_ACK               = 6,            -- StartGame
    PACHIN_G2U_SPIN_ACK						= 7,			-- Spin
    PACHIN_G2U_STOP_REEL_ACK                = 8,			-- StopReel
    PACHIN_G2U_ADD_MONEY_IN_ACK			    = 9,            -- AddMoney
    PACHIN_G2U_USE_CARD_ACK                 = 10,           -- UseCard
    PACHIN_G2U_PLUGIN_CUSTOM_ACK            = 11,           -- PluginCustom
    PACHIN_G2U_USER_INFO_ACK                = 12,           -- UserInfoAck
}

cc.Protocol = {}
cc.Protocol.PachinG2UProtocol = PACHIN_G2U_PROTOCOL
cc.Protocol.PachinU2GProtocol = PACHIN_U2G_PROTOCOL