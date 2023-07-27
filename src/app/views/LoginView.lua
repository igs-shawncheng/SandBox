
local LoginView = class("LoginView", cc.load("mvc").ViewBase)

LoginView.RESOURCE_FILENAME = "Game/LoginView.csb"
LoginView.RESOURCE_BINDING = {
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
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.LOGIN,
    cc.exports.define.EVENTS.LOGOUT,
}

function LoginView:onCreate()
    print("LoginView:onCreate")

    self:RegisterEvent()
end

function LoginView:RegisterEvent()
    print("LoginView:RegisterEvent")

    local function eventHander( event )
        if event:getEventName() == tostring( cc.exports.define.EVENTS.LOGIN ) then
            self:setVisible( false )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.LOGOUT ) then
            self:setVisible( true )
        end
    end

    for i, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function LoginView:OnEnter()
    print("LoginView:OnEnter()")

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

function LoginView:OnExit()
    print("LoginView:OnExit()")
end

function LoginView:OnUpdate( dt )
end

function LoginView:OnClickedLoginBtn( event )
    if event.name == "ended" then
        self:ReqLogin()
    end
end

function LoginView:ReqLogin()
    -- 登入Server
    print("機台號碼:", tonumber(self.m_eb_input:getText()))

    -- 待串登入協定
    self:OnLoginAck()
end

function LoginView:OnLoginAck()
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SET_ARCADE_NO, tonumber(self.m_eb_input:getText()) )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, 5678 )

    cc.exports.dispatchEvent( cc.exports.define.EVENTS.LOGIN )
end

return LoginView
