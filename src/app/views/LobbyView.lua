local LobbyView = class("LobbyView", cc.load("mvc").ViewBase)

LobbyView.RESOURCE_FILENAME = "Game/LobbyView.csb"
LobbyView.RESOURCE_BINDING = {
    ["img_roomInput"] = {
        ["varname"] = "m_roomInput",
    },
    ["btn_Enter"] = {
        ["varname"] = "m_btn_enter",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedEnter"
            }
        }
    },
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.LOGIN_SUCCESS,
    cc.exports.define.EVENTS.JOINGAME,
    cc.exports.define.EVENTS.LEAVEGAME,
}

function LobbyView:onCreate()
    print("LobbyView:onCreate")
    self.lobbySystem = cc.SubSystemBase:GetInstance():GetSystem(cc.exports.SystemName.LobbySystem)
    
    self:RegisterEvent()
    self:setVisible(false)
end

function LobbyView:RegisterEvent()
    print("LobbyView:RegisterEvent")

    local function eventHander( event )
        print("LobbyView:event",event)
        if event:getEventName() == tostring( cc.exports.define.EVENTS.LOGIN_SUCCESS ) then
            self:setVisible( true )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.JOINGAME ) then
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

function LobbyView:OnEnter()
    print("LobbyView:OnEnter()")
    -- 直接進入遊戲
    if cc.exports.define.TEST_WITH_CONNECT then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOINGAME )
        return
    end

    self.m_room_input = ccui.EditBox:create( self.m_roomInput:getContentSize(), cc.exports.define.BLANK_PNG, ccui.TextureResType.localType )
    self.m_room_input:setPosition( cc.p( self.m_roomInput:getPosition() ) )
    self.m_room_input:setInputMode( 6 )
    self.m_room_input:setMaxLength( 2 )
    self.m_room_input:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_room_input:setFontColor( cc.c4b( 0, 0, 0, 255 ) )
    self.m_room_input:setFontSize( 20 )
    self.m_room_input:setReturnType( 1 )  -- DONE
    self.m_room_input:setPlaceholderFont( cc.exports.define.DEFAULT_FONT, 25 )
    self.m_room_input:setPlaceholderFontColor( cc.c4b( 206, 154, 223, 255 ) )
    self.m_room_input:setPlaceHolder( "room number" )
    self:addChild( self.m_room_input )
end

function LobbyView:OnExit()
    print("LobbyView:OnExit()")
end

function LobbyView:OnClickedEnter( event )
    if event.name == "ended" then
        local roomIndex = self.m_room_input:getText();
        self.lobbySystem:RequestJoinRoom(roomIndex)
    end
end

function LobbyView:OnClickedBackBtn()
    self.loginSystem = cc.SubSystemBase:GetInstance():GetSystem(cc.exports.SystemName.LoginSystem)
    --to do logout

    self:setVisible(false)
end

function LobbyView:OnLeaveGame()
    self:setVisible( true )
    self.m_room_input:setText( "" )
    self.m_room_input:setPlaceHolder( "input room number" )
end

return LobbyView