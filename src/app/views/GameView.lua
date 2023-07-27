
local GameView = class("GameView", cc.load("mvc").ViewBase)

GameView.RESOURCE_FILENAME = "Game/GameView.csb"
GameView.RESOURCE_BINDING = {
    ["s_Default"] = {
        ["varname"] = "m_s_default",
    },
    ["img_Input"] = {
        ["varname"] = "m_img_input",
    },
    ["btn_Login"] = {
        ["varname"] = "m_btn_login",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedLoginBtn"
            }
        }
    },
    ["n_JoyTube_Output"] = {
        ["varname"] = "m_joyTubeOutput",
    },
    ["n_JoyTube_Input"] = {
        ["varname"] = "m_joyTubeInput",
    }
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.LOGOUT,
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

    local testInt = Inanna.GetJoyTube().m_testInt
    print("Inanna.GetJoyTube().m_testInt", testInt)

    self.m_state = cc.exports.FiniteState:create( GAMEVIEW_STATE.WAIT_LOGIN )

    self:RegisterEvent()
end

function GameView:RegisterEvent()
    print("GameView:RegisterEvent")

    local function eventHander( event )
        if event:getEventName() == tostring( cc.exports.define.EVENTS.LOGOUT ) then
            self:ReqLogout()
        end
    end

    for i, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function GameView:OnEnter()
    print("GameView:OnEnter()")

    self:InitJoyTube()

    self.m_eb_input = ccui.EditBox:create( self.m_img_input:getContentSize(), cc.exports.define.BLANK_PNG, ccui.TextureResType.localType )
    self.m_eb_input:setPosition( cc.p( self.m_img_input:getPosition() ) )
    self.m_eb_input:setInputMode( 6 )
    self.m_eb_input:setMaxLength( 4 )
    self.m_eb_input:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_eb_input:setFontColor( cc.c4b( 0, 0, 0, 255 ) )
    self.m_eb_input:setFontSize( 25 )
    self.m_eb_input:setReturnType( 1 )  -- DONE
    self.m_eb_input:setPlaceholderFont( cc.exports.define.DEFAULT_FONT, 25 )
    self.m_eb_input:setPlaceholderFontColor( cc.c4b( 206, 154, 223, 255 ) )
    self.m_eb_input:setPlaceHolder( "請輸入機台號碼" )
    
    self:addChild( self.m_eb_input )
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
    Inanna.GetJoyTube():Init( self.m_joyTubeOutput )
end

function GameView:OnExit()
    print("GameView:OnExit()")
end

function GameView:OnUpdate( dt )
    local currentState = self.m_state:Tick()
    if currentState == GAMEVIEW_STATE.WAIT_LOGIN then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.WAIT_LOGIN")

            self.m_s_default:setVisible( true )
            self.m_btn_login:setVisible( true )
            self.m_eb_input:setVisible( true )

            self.m_touch_layer:setTouchEnabled( false )
            self.m_joyTubeOutput:setVisible( false )

            cc.exports.dispatchEvent( cc.exports.define.EVENTS.SET_ARCADE_NO, 0 )
            cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, 0 )
        end
    elseif currentState == GAMEVIEW_STATE.INIT then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.INIT")

            self.m_s_default:setVisible( false )
            self.m_btn_login:setVisible( false )
            self.m_eb_input:setVisible( false )

            self.m_touch_layer:setTouchEnabled( true )
            self.m_joyTubeOutput:setVisible( true )

            self.m_state:Transit( GAMEVIEW_STATE.IDLE )
        end
    elseif currentState == GAMEVIEW_STATE.IDLE then
        if self.m_state:IsEntering() then
            print("GAMEVIEW_STATE.IDLE")
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
        end
    end
end

function GameView:OnClickedLoginBtn( event )
    -- dump( event, "GameView:OnClickedLoginBtn event", 10 )
    if event.name == "ended" then
        if self.m_state:Current() == GAMEVIEW_STATE.WAIT_LOGIN then
            self:ReqLogin()
        end
    end
end

function GameView:ReqLogin()
    -- 登入Server
    print("機台號碼:", tonumber(self.m_eb_input:getText()))

    -- 待串登入協定
    self:OnLoginAck()
end

function GameView:OnLoginAck()
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SET_ARCADE_NO, tonumber(self.m_eb_input:getText()) )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, 5678 )

    self.m_state:Transit( GAMEVIEW_STATE.INIT )
end

function GameView:ReqLogout()
    -- 登出Server

    -- 待串登出協定
    self:OnLogoutAck()
end

function GameView:OnLogoutAck()
    self.m_state:Transit( GAMEVIEW_STATE.WAIT_LOGIN )
end

return GameView
