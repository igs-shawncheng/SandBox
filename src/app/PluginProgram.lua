require "app.system.SubSystemBase"

local PluginProgram = class( "PluginProgram" ) 
PluginProgram.__index = PluginProgram

PluginProgram.m_isMute = false
PluginProgram.m_isInputActive = true

local ERROR_DEFINE = {
	NONE = 0,
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
    print("Inanna.GetJoyTube().m_testInt", testInt)
	
	self:InitSourcePath()
	

	local left = 0
	local top = 0
	local width = CC_DESIGN_RESOLUTION.width
	local height = CC_DESIGN_RESOLUTION.height -- 可能要減掉NavigationView
	local useLocal = true
	Inanna.GetJoyTube():InitPlugin( left, top, width, height, useLocal )

	self:RegisterCreditEventCB()
	self:RegisterErrorStatusCB()
	self:RegisterSystemEvent()
	self:ScheduleUpdate()
	self.sandBoxSystem = cc.SubSystemBase:GetInstance():GetSystem(cc.exports.SystemName.SandBoxSystem)
end

function PluginProgram:InitSourcePath()
	print("PluginProgram:Init() sourcePath:", NATIVE_RESOURCE_PATH)
	Inanna.GetJoyTube():SetSourcePath( NATIVE_RESOURCE_PATH )
end

function PluginProgram:Update()
	local messageId = Inanna.GetJoyTube():IsPostMessage()
	if messageId > 0 then
		local postMessage = Inanna.GetJoyTube():GetPostMessageString()
        self.sandBoxSystem:RequestCustomMessage(postMessage)
	end
end

function PluginProgram:OnLeaveGame()
	Inanna.GetJoyTube():OnLeaveGame()
end

function PluginProgram:SetMusicMute( isMute )
	if self.m_isMute == isMute then return end

	self.m_isMute = isMute
	Inanna.GetJoyTube():SetMusicMute( isMute )

	cc.exports.dispatchEvent( cc.exports.define.EVENTS.MUTE_SETTING_CHANGED, isMute )
end

function PluginProgram:GetMusicMute()
	return self.m_isMute
end

function PluginProgram:SetGameInfoOpen( isOpen )
	Inanna.GetJoyTube():SetGameInfoOpen( isOpen )
end

-- 關閉輸入避免平台視窗跳出時點到遊戲
function PluginProgram:SetInputActive( isActive )
	if self.m_isInputActive == isActive then return end

	self.m_isInputActive = isActive
	Inanna.GetJoyTube():SetInputActive( isActive )

	cc.exports.dispatchEvent( cc.exports.define.EVENTS.IO_SETTING_CHANGED, isActive )
end

function PluginProgram:GetInputActive()
	return self.m_isInputActive
end

function PluginProgram:RegisterCreditEventCB()
	local function cb( chip )
		cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, chip )
	end
	Inanna.GetJoyTube():RegisterCreditEventCB( cb )
end

function PluginProgram:RegisterErrorStatusCB()
	local function cb( errorStatus )
		-- NET_DELAY = 8
		-- INSUFFICIENT_BALANCE = 6 多執行一次 ResetErrorStatus (?)

		Inanna.GetJoyTube():ResetErrorStatus()
		cc.exports.dispatchEvent( cc.exports.define.EVENTS.PLUGIN_ERROR_STATUS, errorStatus )
	end
	Inanna.GetJoyTube():RegisterErrorStatusCB( cb )
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
	return Inanna.GetJoyTube():GetIsAutoPlay()
end

function PluginProgram:GetGameStatus()
	return Inanna.GetJoyTube():GetGameStatus()
end

function PluginProgram:GetPlayState()
	local playState = Inanna.GetJoyTube():GetPlayState()
	if Inanna.GetJoyTube():IsEnteringSetting() then
		playState = RUN_KIND.INFO_SETTING
	end
	return playState
end

function PluginProgram:Abort()
	Inanna.GetJoyTube():Abort()
end

function PluginProgram:SendMessage(cmd, jsonString)
	--print("Recv PLUGIN_RESPONSE", cmd, jsonString)
	return Inanna.GetJoyTube():SendMessage(cmd, jsonString)
end

function PluginProgram:IsPostMessage()
	return Inanna.GetJoyTube():IsPostMessage()
end

function PluginProgram:GetPostMessageString()
	return Inanna.GetJoyTube():GetPostMessageString()
end

function PluginProgram:OnPullButton(type)
	Inanna.GetJoyTube():OnPullButton(type)
end

function PluginProgram:OnPushButton(type)
	Inanna.GetJoyTube():OnPushButton(type)
end


cc.exports.PluginProgram = PluginProgram
cc.exports.PluginProgram.BUTTON_TYPE = ButtonsType
cc.exports.PluginProgram.ERROR_DEFINE = ERROR_DEFINE
cc.exports.PluginProgram.GAME_STATUS = GAME_STATUS
cc.exports.PluginProgram.RUN_KIND = RUN_KIND