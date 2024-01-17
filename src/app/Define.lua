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

	JOINGAME ="joingame",
	LEAVEGAME = "leavegame",

    CHIP_UPDATE = "chip_update",
    SET_ARCADE_NO = "set_arcade_no",

    PLUGIN_ERROR_STATUS = "plugin_error_status",
	PLUGIN_RESPONSE = "plugin_response",

    SHOW_MSG = "show_msg",

    FREE_SPIN_CARD_TOTAL_BET = "free_spin_card_total_bet",
    FREE_SPIN_CARD_INFO = "free_spin_card_info",
    FREE_SPIN_CARD_SHOW = "free_spin_card_show",
    FREE_SPIN_CARD_HIDE = "free_spin_card_hide",

	NET_ON_DISCONNECT = "net_on_disconnect",
	NET_ON_RECONNECT = "net_on_reconnect",
	NET_ON_CONNECTED = "net_on_connect",

	LOGIN_SUCCESS = "login_success",
	LOGOUT = "logout",

	ROOM_INFO_ACK = "room_info_ack",
	GAME_INFO_ACK = "game_info_ack",

	DOWNLOAD = "download",
	DOWNLOAD_PROGRESS = "download_progress"
}

local  GameMode = {
	GameMode_Normal		= 0,
	GameMode_MTB		= 1,
	GameMode_MTA		= 2,
};

local DEFAULT_FONT = "Microsoft JhengHei"  -- 微軟正黑體

local BLANK_PNG = "Platform/BlankPNG.png"

local TEST_WITH_CONNECT = false

local SPLIT_DATA_PACKET_SIZE = 1000

local DOWNLOAD_GAME_DATA = {
	{ url = "https://cdn.gametower.com.tw/rd5/tmd_mobile/data/win/FishHunter/FishHunterResource/FishHunterResource.zip?cbeddfd77c5ff46010261a3ba39826ff",
	destination = "./FishHunterResource.zip" },
}

local DOWNLOAD_VERSION_DATA = {
	url = "https://cdn-g.gametower.com.tw/rd5/tmd_mobile/data/win/Inanna/InannaLua/Version.json",
	destination = "./NewVersion.json",
}

local LOCAL_VERSION_DATA = "./LocalVersion.json"

cc.exports.define = {}
cc.exports.define.GameMode = GameMode
cc.exports.define.EVENTS = EVENTS
cc.exports.define.DEFAULT_FONT = DEFAULT_FONT
cc.exports.define.BLANK_PNG = BLANK_PNG
cc.exports.define.TEST_WITH_CONNECT = TEST_WITH_CONNECT
cc.exports.define.SPLIT_DATA_PACKET_SIZE = SPLIT_DATA_PACKET_SIZE
cc.exports.define.DOWNLOAD_GAME_DATA = DOWNLOAD_GAME_DATA
cc.exports.define.DOWNLOAD_VERSION_DATA = DOWNLOAD_VERSION_DATA
cc.exports.define.LOCAL_VERSION_DATA = LOCAL_VERSION_DATA