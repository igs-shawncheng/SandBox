
local GameView = class("GameView", cc.load("mvc").ViewBase)

GameView.RESOURCE_FILENAME = "Game/GameView.csb"
GameView.RESOURCE_BINDING = {
    ["n_JoyTube_Output"] = {
        ["varname"] = "m_joyTubeOutput",
    },
    ["n_JoyTube_Input"] = {
        ["varname"] = "m_joyTubeInput",
    },
    ["n_GameStatus"] = {
        ["varname"] = "m_n_gameStatus",
    },
    ["txt_GameStatus"] = {
        ["varname"] = "m_txt_gameStatus",
    },
    ["txt_PlayState"] = {
        ["varname"] = "m_txt_playState",
    }
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.LOGIN,
    cc.exports.define.EVENTS.CLICKED_BACK_BTN,
    cc.exports.define.EVENTS.LOGOUT,
    cc.exports.define.EVENTS.PLUGIN_ERROR_STATUS,
    cc.exports.define.EVENTS.CLICKED_GAME_STATUS_BTN,
    cc.exports.define.EVENTS.CLICKED_INFO_BTN,
    cc.exports.define.EVENTS.CLICKED_ITEM_BTN,
    cc.exports.define.EVENTS.CLICKED_MUSIC_BTN,
    cc.exports.define.EVENTS.CLICKED_INPUT_BTN,
}

local GAMEVIEW_STATE = {
    WAIT_LOGIN = 1, -- 等待登入Server
    INIT = 2,       -- 登入後初始化

    IDLE = 10,  -- 等待spin
    START = 11, -- 開始轉動
    SPIN = 12,  -- 轉動中
    STOP = 13,  -- 停止
    AWARD = 14, -- 得獎表演

    CHECK_FREE_SPIN_CARD = 30,  -- 轉次卡

    END = 50,   -- 結束

    ERROR = 100,    -- 錯誤狀態
}

function GameView:onCreate()
    print("GameView:onCreate")

    self.m_state = cc.exports.FiniteState:create( GAMEVIEW_STATE.WAIT_LOGIN )
    self.m_pluginProgram = cc.exports.PluginProgram:create()

    self.m_isUseItem = false

    self:RegisterEvent()
end

function GameView:RegisterEvent()
    print("GameView:RegisterEvent")

    local function eventHander( event )
        if event:getEventName() == tostring( cc.exports.define.EVENTS.LOGIN ) then
            self:OnLogin()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.LOGOUT ) then
            self:OnLogout()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.CLICKED_BACK_BTN ) then
            self:OnClickedBackBtn()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.PLUGIN_ERROR_STATUS ) then
            self:OnPluginErrorStatus( event._usedata )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.CLICKED_GAME_STATUS_BTN ) then
            self.m_n_gameStatus:setVisible( not self.m_n_gameStatus:isVisible() )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.CLICKED_INFO_BTN ) then
            self.m_pluginProgram:SetGameInfoOpen( true ) -- 僅打開，關閉會在日方遊戲中關閉說明頁
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.CLICKED_ITEM_BTN ) then
            self:OnClickedItemBtn()
            self.m_pluginProgram:SetGameInfoOpen( false )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.CLICKED_MUSIC_BTN ) then
            self.m_pluginProgram:SetMusicMute( not self.m_pluginProgram:GetMusicMute() )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.CLICKED_INPUT_BTN ) then
            self.m_pluginProgram:SetInputActive( not self.m_pluginProgram:GetInputActive() )
        end
    end

    for i, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function GameView:OnLogin()
    self.m_state:Transit( GAMEVIEW_STATE.INIT )
end

function GameView:OnLogout()
    self.m_pluginProgram:OnLeaveGame()
    self.m_state:Transit( GAMEVIEW_STATE.WAIT_LOGIN )
end

function GameView:OnClickedBackBtn()
    if self.m_state:Current() == GAMEVIEW_STATE.WAIT_LOGIN then
        return
    end

    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
    {
        title = "提示訊息",
        content = "是否登出？",
        confirmCB = function ()
            print("click confirmCB")
            if self.m_state:Current() ~= GAMEVIEW_STATE.WAIT_LOGIN then
                cc.exports.dispatchEvent( cc.exports.define.EVENTS.LOGOUT )
            end
        end,
        cancelCB = function ()
            print("click cancelCB")
        end,
    } )
end

function GameView:OnPluginErrorStatus( errorStatus )
    -- 處理 errorStatus
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
    {
        title = "PluginErrorStatus",
        content = "errorStatus: " .. errorStatus,
        confirmCB = function ()
            print("click confirmCB")
        end,
        cancelCB = function ()
            print("click cancelCB")
        end,
        btnPosType = 1,
    } )

    self.m_state:Transit( GAMEVIEW_STATE.ERROR )
end

function GameView:OnClickedItemBtn()
    -- 測試道具卡介面
    if self.m_isUseItem then
        self.m_itemLeftTimes = self.m_itemLeftTimes - 1
        self.m_itemTotalWin = self.m_itemTotalWin + 1000
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.FREE_SPIN_CARD_INFO,
        {
            leftTimes = self.m_itemLeftTimes,
            totalWin = string.formatnumberthousands( self.m_itemTotalWin ),
            totalCount = self.m_itemTotalCount,
        } )

        if self.m_itemLeftTimes == 0 then
            cc.exports.dispatchEvent( cc.exports.define.EVENTS.FREE_SPIN_CARD_HIDE )
            self.m_isUseItem = false
        end

        return
    end

    self.m_isUseItem = true

    self.m_itemLeftTimes = 10
    self.m_itemTotalWin = 0
    self.m_itemTotalCount = 10
    self.m_itemTotalBet = 1000

    cc.exports.dispatchEvent( cc.exports.define.EVENTS.FREE_SPIN_CARD_INFO,
    {
        leftTimes = self.m_itemLeftTimes,
        totalWin = string.formatnumberthousands( self.m_itemTotalWin ),
        totalCount = self.m_itemTotalCount,
    } )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.FREE_SPIN_CARD_TOTAL_BET, string.formatnumberthousands( self.m_itemTotalBet ) )

    cc.exports.dispatchEvent( cc.exports.define.EVENTS.FREE_SPIN_CARD_SHOW )
end

function GameView:OnEnter()
    print("GameView:OnEnter()")

    self.m_n_gameStatus:setVisible( false )

    self:InitJoyTube()
end

function GameView:InitJoyTube()
    -- input
    self.m_touch_layer = cc.LayerColor:create( cc.c4b( 0, 0, 0, 0 ), CC_DESIGN_RESOLUTION.width, CC_DESIGN_RESOLUTION.height )
    self.m_touch_layer:move( display.left_bottom )
    self.m_touch_layer:addTo( self.m_joyTubeInput )
    self.m_touch_layer:onTouch( function( event )
        print("layer onTouch x:" .. event.x .. " y:" .. event.y)
        local sceneY = (display.height - CC_DESIGN_RESOLUTION.height) / 2
        Inanna.GetJoyTube():OnTouch( event.x, event.y - sceneY )
    end )

    -- output
    Inanna.GetJoyTube():AddSprite( self.m_joyTubeOutput )
end

function GameView:OnExit()
    print("GameView:OnExit()")
end

function GameView:OnUpdate( dt )
    local currentState = self.m_state:Tick()
    if currentState == GAMEVIEW_STATE.WAIT_LOGIN then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.WAIT_LOGIN")

            self:setVisible( false )
            self.m_touch_layer:setTouchEnabled( false )
            self.m_joyTubeOutput:setVisible( false )
        end
    elseif currentState == GAMEVIEW_STATE.INIT then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.INIT")

            self:setVisible( true )
            self.m_touch_layer:setTouchEnabled( true )
            self.m_joyTubeOutput:setVisible( true )

            self.m_pluginProgram:SetMusicMute( true )
            self.m_pluginProgram:Init( "testSourcePath" )
            self.m_state:Transit( GAMEVIEW_STATE.IDLE )
        end
    elseif currentState == GAMEVIEW_STATE.IDLE then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.IDLE")
            cc.exports.dispatchEvent(cc.exports.define.EVENTS.PLUGIN_RESPONSE, {10, 20})
        end
    elseif currentState == GAMEVIEW_STATE.START then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.START")
        end

        -- test Elapsed()
        -- if self.m_state:Elapsed() >= 3 then
        --     self.m_state:Transit( GAMEVIEW_STATE.SPIN )
        -- end
    elseif currentState == GAMEVIEW_STATE.SPIN then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.SPIN")
        end
    elseif currentState == GAMEVIEW_STATE.STOP then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.STOP")
        end
    elseif currentState == GAMEVIEW_STATE.AWARD then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.AWARD")
        end
    elseif currentState == GAMEVIEW_STATE.CHECK_FREE_SPIN_CARD then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.CHECK_FREE_SPIN_CARD")
        end
    elseif currentState == GAMEVIEW_STATE.END then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.END")
        end
    elseif currentState == GAMEVIEW_STATE.ERROR then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.ERROR")

            self.m_pluginProgram:Abort()
        end
    end

    self.m_txt_gameStatus:setString( "GameStatus: " .. self.m_pluginProgram:GetGameStatus() )
    self.m_txt_playState:setString( "PlayState: " .. self.m_pluginProgram:GetPlayState() )
end

return GameView
