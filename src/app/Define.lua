local EVENTS = {
	CLICKED_BACK_BTN = "clicked_back_btn",

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