local LoginView = class("LoginView", cc.load("mvc").ViewBase)

LoginView.RESOURCE_FILENAME = "Game/LoginView.csb"
LoginView.RESOURCE_BINDING = {
    ["s_Default"] = {
        ["varname"] = "m_s_default",
    },
    ["img_ipInput"] = {
        ["varname"] = "m_ipInput",
    },
    ["img_accountInput"] = {
        ["varname"] = "m_accountInput",
    },
    ["img_roomInput"] = {
        ["varname"] = "m_roomInput",
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
    cc.exports.define.EVENTS.JOINGAME,
    cc.exports.define.EVENTS.LEAVEGAME,
}

function LoginView:onCreate()
    print("LoginView:onCreate")
 
    self.loginSystem = cc.SubSystemBase:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    
    self:RegisterEvent()
end

function LoginView:RegisterEvent()
    print("LoginView:RegisterEvent")

    local function eventHander( event )
        print("LoginView:event",event)
        if event:getEventName() == tostring( cc.exports.define.EVENTS.JOINGAME ) then
            self:setVisible( false )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.LEAVEGAME ) then
            self:OnLeaveGame()
        end
    end

    for _, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function LoginView:OnEnter()
    print("LoginView:OnEnter()")
    -- 直接進入遊戲
    if cc.exports.define.TEST_WITH_CONNECT then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOINGAME )
        return
    end

    self.m_ip_input = ccui.EditBox:create( self.m_ipInput:getContentSize(), cc.exports.define.BLANK_PNG, ccui.TextureResType.localType )
    self.m_ip_input:setPosition( cc.p( self.m_ipInput:getPosition() ) )
    self.m_ip_input:setInputMode( 6 )
    self.m_ip_input:setMaxLength( 4 )
    self.m_ip_input:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_ip_input:setFontColor( cc.c4b( 0, 0, 0, 255 ) )
    self.m_ip_input:setFontSize( 25 )
    self.m_ip_input:setReturnType( 1 )  -- DONE
    self.m_ip_input:setPlaceholderFont( cc.exports.define.DEFAULT_FONT, 25 )
    self.m_ip_input:setPlaceholderFontColor( cc.c4b( 206, 154, 223, 255 ) )
    self.m_ip_input:setPlaceHolder( "ip EX:192.168.44.101" )
    self:addChild( self.m_ip_input )

    self.m_account_input = ccui.EditBox:create( self.m_accountInput:getContentSize(), cc.exports.define.BLANK_PNG, ccui.TextureResType.localType )
    self.m_account_input:setPosition( cc.p( self.m_accountInput:getPosition() ) )
    self.m_account_input:setInputMode( 6 )
    self.m_account_input:setMaxLength( 4 )
    self.m_account_input:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_account_input:setFontColor( cc.c4b( 0, 0, 0, 255 ) )
    self.m_account_input:setFontSize( 25 )
    self.m_account_input:setReturnType( 1 )  -- DONE
    self.m_account_input:setPlaceholderFont( cc.exports.define.DEFAULT_FONT, 25 )
    self.m_account_input:setPlaceholderFontColor( cc.c4b( 206, 154, 223, 255 ) )
    self.m_account_input:setPlaceHolder( "account number" )
    self:addChild( self.m_account_input )

    self.m_room_input = ccui.EditBox:create( self.m_roomInput:getContentSize(), cc.exports.define.BLANK_PNG, ccui.TextureResType.localType )
    self.m_room_input:setPosition( cc.p( self.m_roomInput:getPosition() ) )
    self.m_room_input:setInputMode( 6 )
    self.m_room_input:setMaxLength( 4 )
    self.m_room_input:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_room_input:setFontColor( cc.c4b( 0, 0, 0, 255 ) )
    self.m_room_input:setFontSize( 25 )
    self.m_room_input:setReturnType( 1 )  -- DONE
    self.m_room_input:setPlaceholderFont( cc.exports.define.DEFAULT_FONT, 25 )
    self.m_room_input:setPlaceholderFontColor( cc.c4b( 206, 154, 223, 255 ) )
    self.m_room_input:setPlaceHolder( "room number" )
    self:addChild( self.m_room_input )
end

function LoginView:OnExit()
    print("LoginView:OnExit()")
end

function LoginView:OnClickedLoginBtn( event )
    if event.name == "ended" then
        local ip = self.m_ip_input:getText();
        local accountId = self.m_account_input:getText();
        local roomIndex = self.m_room_input:getText();
        self.loginSystem:Connect(ip, accountId, roomIndex)
    end
end

function LoginView:OnLeaveGame()
    self:setVisible( true )
    self.m_room_input:setText( "" )
    self.m_room_input:setPlaceHolder( "input room number" )
end

return LoginView