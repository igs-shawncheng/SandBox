local FreeSpinCardView = class("FreeSpinCardView", cc.load("mvc").ViewBase)

FreeSpinCardView.RESOURCE_FILENAME = "Platform/gameCommonUI/freeSpinCard/FreeSpinCardView_HS.csb"
FreeSpinCardView.RESOURCE_BINDING = {
    ["BMFont_totalBet"] = {
        ["varname"] = "m_txt_totalBet",
    },
    ["BMFont_leftTimes"] = {
        ["varname"] = "m_txt_leftTimes",
    },
    ["BMFont_totalWin"] = {
        ["varname"] = "m_txt_totalWin",
    },
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.FREE_SPIN_CARD_TOTAL_BET,
    cc.exports.define.EVENTS.FREE_SPIN_CARD_INFO,
    cc.exports.define.EVENTS.FREE_SPIN_CARD_SHOW,
    cc.exports.define.EVENTS.FREE_SPIN_CARD_HIDE,
    cc.exports.define.EVENTS.LEAVEGAME,
}

local INFO = {
    leftTimes = 0,
    totalWin = 0,
    totalCount = 0,
}

function FreeSpinCardView:onCreate()
    print("FreeSpinCardView:onCreate")

    self:setVisible( false )

    self.m_timeline = cc.CSLoader:createTimeline( self.RESOURCE_FILENAME )
    self:runAction( self.m_timeline )
    self.m_timeline:setFrameEventCallFunc(
        function( frame )
            if frame:getEvent() == "AniEnd" then
                self:setVisible( false )
                self.m_txt_totalWin:setString( "0" )
            end
        end
    )

    self.m_txt_totalBet:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_txt_leftTimes:setFontName( cc.exports.define.DEFAULT_FONT )

    self:RegisterEvent()
end

function FreeSpinCardView:RegisterEvent()
    print("FreeSpinCardView:RegisterEvent")

    local function eventHander( event )
        if event:getEventName() == tostring( cc.exports.define.EVENTS.FREE_SPIN_CARD_TOTAL_BET ) then
            self:SetTotalBet( event._usedata )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.FREE_SPIN_CARD_INFO ) then
            self:UpdateInfo( event._usedata )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.FREE_SPIN_CARD_SHOW ) then
            self:Show()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.FREE_SPIN_CARD_HIDE ) then
            self:Hide()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.LEAVEGAME ) then
            self:Hide()
        end
    end

    for i, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function FreeSpinCardView:OnEnter()
    print("FreeSpinCardView:OnEnter()")
end

function FreeSpinCardView:OnExit()
    print("FreeSpinCardView:OnExit()")
end

function FreeSpinCardView:Show()
    self:setVisible( true )
    self.m_timeline:play( "Start", false )
end

function FreeSpinCardView:Hide()
    self:setVisible( false )
    self.m_timeline:play( "End", false )
end

function FreeSpinCardView:SetTotalBet( totalBet )
    self.m_txt_totalBet:setString( tostring( totalBet ) )
end

function FreeSpinCardView:UpdateInfo( info )
    self.m_txt_leftTimes:setString( tostring( info.leftTimes ) .. "/" .. tostring( info.totalCount ) )
    self.m_txt_totalWin:setString( tostring( info.totalWin ) )
end

return FreeSpinCardView