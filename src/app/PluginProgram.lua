require "app.system.SubSystemBase"

local PluginProgram = class( "PluginProgram" ) 
PluginProgram.__index = PluginProgram

PluginProgram.m_isMute = false
PluginProgram.m_isInputActive = true

local ERROR_DEFINE = {
	NONE = 0,                   -- Error does not occur
	SCEAN_CREATE_ERROR = 1,     -- I failed to create a screen
	RESOURCE_LOAD_ERROR = 2,    -- The resource failed to load
	SLOT_ERROR = 3,             -- There was an error in the slot
	SEND_MESSAGE_ERROR = 4,     -- Failed to create the data to be sent
	RECEVE_MESSAGE_ERROR = 5,   -- I failed to analyze the incoming data
	INSUFFICIENT_BALANCE = 6,   -- Insufficient amount of money in the player's SPIN
	INIT_ERROR = 7,             -- No related packets received for more than 5 seconds after initialization
	NET_DELAY = 8,              -- Packets are not received for more than 5 seconds per process
	DRIVER_ERROR = 9,           -- Hardware functions are not supported (e.g. simulator does not work)
	NET_DATA_ERROR = 10,        -- Packet data error (e.g., incorrect bureau number, illegal value)
	MEMORY_ERROR = 11,          -- Insufficient memory
}

local GAME_STATUS = {
	BETWAIT = 0,        -- Waiting for MaxBet button to be pressed
	LEVERWAIT = 1,      -- Waiting for the lever to be pressed
	ROTATEWAIT = 2,     -- waiting for the start of rotation
	STOPWAIT_1 = 3,     -- Waiting for the stop button to be pressed
	STOPWAIT_2 = 4,     -- Waiting for the stop button to be pressed
	STOPWAIT_3 = 5,     -- Waiting for the stop button to be pressed
	ALLREELSTOP = 6,    -- Waiting for all reels to stop
	PAYOUT = 7,         -- paying out
	GAMEEND = 8,        -- End of one game
	AUTO_PLAY = 9,      -- Normal Auto
	AUTO_ITEM = 10,     -- Auto during item use
}

local RUN_KIND = {
	NORMAL = 0,         -- Normal
	ASSIST_TIME = 1,    -- Assist Time
	INFO_SETTING = 2,   -- Infomation or Setting Menu
}

local ButtonsType = {
    MAXBET = 0,
    LEVER = 1,
    STOP_L = 2,
    STOP_C = 3,
    STOP_R = 4,
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.PLUGIN_RESPONSE,
}

local CHECK_PLUGIN_INTERVAL = 0.05

function PluginProgram:extend( target )
	setmetatable( target, PluginProgram )
	return target
end

function PluginProgram:create()
	return PluginProgram:extend( {} )
end

function PluginProgram:Init()
	

	local testInt = Inanna.GetJoyTube().m_testInt

	self.sandBoxSystem = cc.SubSystemBase:GetInstance():GetSystem(cc.exports.SystemName.SandBoxSystem)
end

function PluginProgram:Update()
end

function PluginProgram:OnLeaveGame()

end

function PluginProgram:SetMusicMute( isMute )
	if self.m_isMute == isMute then return end

	self.m_isMute = isMute


	cc.exports.dispatchEvent( cc.exports.define.EVENTS.MUTE_SETTING_CHANGED, isMute )
end

function PluginProgram:GetMusicMute()
	return self.m_isMute
end

function PluginProgram:SetGameInfoOpen( isOpen )

end

-- 關閉輸入避免平台視窗跳出時點到遊戲
function PluginProgram:SetInputActive( isActive )
	if self.m_isInputActive == isActive then return end

	self.m_isInputActive = isActive

	cc.exports.dispatchEvent( cc.exports.define.EVENTS.IO_SETTING_CHANGED, isActive )
end

function PluginProgram:GetInputActive()
	return self.m_isInputActive
end

function PluginProgram:RegisterCreditEventCB()
	local function cb( chip )
		cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, chip )
	end
end

function PluginProgram:RegisterErrorStatusCB()
	local function cb( errorStatus )
		-- NET_DELAY = 8
		-- INSUFFICIENT_BALANCE = 6 多執行一次 ResetErrorStatus (?)

		cc.exports.dispatchEvent( cc.exports.define.EVENTS.PLUGIN_ERROR_STATUS, errorStatus )
	end
end

function PluginProgram:RegisterSystemEvent()
	local function eventHander( event )
		print("Recv PLUGIN_RESPONSE", event._usedata[1], event._usedata[2])
		if event:getEventName() == cc.exports.define.EVENTS.PLUGIN_RESPONSE then
			self:SendMessage(0, event._usedata[1], event._usedata[2])
		end
	end

	for _, eventName in pairs( REGISTER_EVENTS ) do
		local listener = cc.EventListenerCustom:create( eventName, eventHander )
		local dispatcher = cc.Director:getInstance():getEventDispatcher()
		dispatcher:addEventListenerWithFixedPriority( listener, 10 )
	end
end

function PluginProgram:ScheduleUpdate()
	local schedule = cc.Director:getInstance():getScheduler()
	self._schedulerID = schedule:scheduleScriptFunc(handler(self, self.Update), CHECK_PLUGIN_INTERVAL, false)
end

function PluginProgram:GetIsAutoPlay()
end

function PluginProgram:GetGameStatus()
end

function PluginProgram:GetPlayState()
	return RUN_KIND.INFO_SETTING
end

function PluginProgram:Abort()
end

function PluginProgram:SendMessage(cmd, jsonString)
	--print("Recv PLUGIN_RESPONSE", cmd, jsonString)
end

function PluginProgram:IsPostMessage()
end

function PluginProgram:GetPostMessageString()
end

-- function PluginProgram:OnPullButton(type)
-- 	Inanna.GetJoyTube():OnPullButton(type)
-- end

-- function PluginProgram:OnPushButton(type)
-- 	Inanna.GetJoyTube():OnPushButton(type)
-- end


cc.exports.PluginProgram = PluginProgram
cc.exports.PluginProgram.BUTTON_TYPE = ButtonsType
cc.exports.PluginProgram.ERROR_DEFINE = ERROR_DEFINE
cc.exports.PluginProgram.GAME_STATUS = GAME_STATUS
cc.exports.PluginProgram.RUN_KIND = RUN_KIND