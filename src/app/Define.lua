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
}

local DEFAULT_FONT = "Microsoft JhengHei"  -- 微軟正黑體

local BLANK_PNG = "Platform/BlankPNG.png"

cc.exports.define = {}
cc.exports.define.EVENTS = EVENTS
cc.exports.define.DEFAULT_FONT = DEFAULT_FONT
cc.exports.define.BLANK_PNG = BLANK_PNG