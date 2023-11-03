require "app.message.PACHIN_U2G_GAME_INFO_REQ"

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
                method ="OnClickedPlayBtn"
            }
        }
    },
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.JOINGAME,
    cc.exports.define.EVENTS.LEAVEGAME,
    cc.exports.define.EVENTS.ROOM_INFO_ACK,
    cc.exports.define.EVENTS.NET_ON_CONNECTED,
    cc.exports.define.EVENTS.LOGIN_SUCCESS,
    cc.exports.define.EVENTS.JOIN_ROOM_ACK,
    cc.exports.define.EVENTS.GAME_INFO_ACK,
}

function LoginView:onCreate()
    print("LoginView:onCreate")

    self.sandBoxSystem = cc.SubSystemBase:GetInstance():GetSystem(cc.exports.SystemName.SandBoxSystem)

    --cc.SubSystemBase:GetInstance():Login("127.0.0.1", "8888")
    -- cc.SubSystemBase:GetInstance():Login("192.168.165.191", "8888") --教和主機ip
    cc.SubSystemBase:GetInstance():Login("192.168.44.101", "8888")

    self.accoundId = 1234
    self.roomIndex = nil
    self.reserve = nil

    self:RegisterEvent()
end

function LoginView:RegisterEvent()
    print("LoginView:RegisterEvent")

    local function eventHander( event )
        print("LoginView:event",event)
        if event:getEventName() == tostring( cc.exports.define.EVENTS.JOINGAME ) then
            self:setVisible( false )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.LEAVEGAME ) then
            self:setVisible( true )
            self.sandBoxSystem:RequestLeaveRoom( self.accoundId, event._usedata)
            self.m_eb_input:setText( "" )
            self.m_eb_input:setPlaceHolder( "請輸入機台號碼" )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.ROOM_INFO_ACK) then
            self.reserve = event._usedata.reserve
            self.roomIndex = event._usedata.roomIndex
            self:ReqJoinGame()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.NET_ON_CONNECTED ) then
            self.sandBoxSystem:RequestLogin(self.accoundId)
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.LOGIN_SUCCESS ) then

        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.JOIN_ROOM_ACK ) then
            self.success = event._usedata.success
            if self.success then
                self:OnJoinGameAck()
            else
                self:OnJoinGameFail( "請洽遊戲客服人員謝謝" )
            end
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.GAME_INFO_ACK ) then
            self:OnGameInfoAck()
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

function LoginView:OnClickedPlayBtn( event )
    if event.name == "ended" then
        self.sandBoxSystem:RequestRoomInfo(self.accoundId)
    end
end

function LoginView:ReqJoinGame()
    -- 登入Server
    local roomIndex = tonumber(self.m_eb_input:getText())
    print("機台號碼:",roomIndex)
    if roomIndex == "" or type( roomIndex ) ~= "number" then
        self:OnJoinGameFail( "機台號碼錯誤" )
        return
    end

    -- 直接進入遊戲
    if cc.exports.define.TEST_WITH_CONNECT then
        self.roomIndex = roomIndex
        self:OnJoinGameAck()
    else

        --新進入的機台與保留機台不一樣
        if self.reserve == true and self.roomIndex ~= roomIndex then
            cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
            {
                title = "系統資訊",
                content = "您目前有保留機台， 機台號碼: " .. self.roomIndex,
                cancelBtnText = "玩保留機台",
                confirmBtnText = "玩新機台",
                showCloseBtn = true,
                confirmCB = function ()
                    print("click confirmCB",roomIndex)
                    self.sandBoxSystem:RequestJoinRoom(self.accoundId,roomIndex)
                    self.roomIndex = roomIndex
                end,
                cancelCB = function ()
                    print("click cancelCB",self.roomIndex)
                    self.sandBoxSystem:RequestJoinRoom(self.accoundId,self.roomIndex)
                end,
                closeCB = function ()
                    print("click closeCB")
                end,
            } )
            return
        end

        self.sandBoxSystem:RequestJoinRoom(self.accoundId,roomIndex)
        self.roomIndex = roomIndex
    end
end

function LoginView:OnJoinGameAck()
    print("RequestGameInfo",self.accoundId,self.roomIndex)
    self.sandBoxSystem:RequestGameInfo(self.accoundId,self.roomIndex)
end

function LoginView:OnGameInfoAck()
    print("OnGameInfoAck",self.roomIndex)
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SET_ARCADE_NO, self.roomIndex )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, 5678 )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOINGAME )
end

function LoginView:OnJoinGameFail( reason )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
    {
        title = "系統資訊",
        content = "加入遊戲失敗: " .. reason,
        confirmCB = function ()
            print("click confirmCB")
        end,
        btnPosType = 1,
    } )
end

return LoginView