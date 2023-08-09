local EVENTS = {
	CLICKED_BACK_BTN = "clicked_back_btn",
	CLICKED_MALL_BTN = "clicked_mall_btn",
	CLICKED_GAME_STATUS_BTN = "clicked_game_status_btn",
	CLICKED_INFO_BTN = "clicked_info_btn",
	CLICKED_ITEM_BTN = "clicked_item_btn",
	CLICKED_MUSIC_BTN = "clicked_music_btn",
	CLICKED_INPUT_BTN = "clicked_input_btn",

	MUTE_SETTING_CHANGED = "mute_setting_changed",
	IO_SETTING_CHANGED = "io_setting_changed",

	LOGIN = "login",
	LOGOUT = "logout",

    CHIP_UPDATE = "chip_update",
    SET_ARCADE_NO = "set_arcade_no",

    PLUGIN_ERROR_STATUS = "plugin_error_status",

    SHOW_MSG = "show_msg",
	
    FREE_SPIN_CARD_TOTAL_BET = "free_spin_card_total_bet",
    FREE_SPIN_CARD_INFO = "free_spin_card_info",
    FREE_SPIN_CARD_SHOW = "free_spin_card_show",
    FREE_SPIN_CARD_HIDE = "free_spin_card_hide",

    NET_LOGIN_SUCCESS = "net_login_success",
	NET_LOGIN_FAIL = "net_login_fail",
	NET_ON_DISCONNECT = "net_on_disconnect",
	NET_ON_RECONNECT = "net_on_reconnect",
}

local DEFAULT_FONT = "Microsoft JhengHei"  -- 微軟正黑體

local BLANK_PNG = "Platform/BlankPNG.png"

local QUICK_TEST = false

cc.exports.define = {}
cc.exports.define.EVENTS = EVENTS
cc.exports.define.DEFAULT_FONT = DEFAULT_FONT
cc.exports.define.BLANK_PNG = BLANK_PNG
cc.exports.define.QUICK_TEST = QUICK_TEST