
local NavigationView = class("NavigationView", cc.load("mvc").ViewBase)

NavigationView.RESOURCE_FILENAME = "Platform/navigation/Navigation.csb"
NavigationView.RESOURCE_BINDING = {
    ["txt_redDiamond"] = {
        ["varname"] = "m_txt_redDiamond"
    },
    ["txt_arcade"] = {
        ["varname"] = "m_txt_arcade"
    },
    ["btn_info"] = {
        ["varname"] = "m_btn_info",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedInfoBtn"
            }
        }
    },
    ["sp_Info"] = {
        ["varname"] = "m_sp_info"
    },
    ["n_prosperous_money"] = {
        ["varname"] = "m_n_prosperous_money"
    },
    ["btn_back"] = {
        ["varname"] = "m_btn_back",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedBackBtn"
            }
        }
    }
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.LOGIN,
    cc.exports.define.EVENTS.LOGOUT,
    cc.exports.define.EVENTS.CHIP_UPDATE,
    cc.exports.define.EVENTS.SET_ARCADE_NO,
}

local GOLD_INGOT_CSB_FILE1 = "Platform/effect/Lobby/GoldingotFX01.csb"

function NavigationView:onCreate()
    print("NavigationView:onCreate")

    self:Init()
    self:RegisterEvent()
end

function NavigationView:Init()
    print("NavigationView:Init")

    self.m_txt_redDiamond:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_txt_arcade:setFontName( cc.exports.define.DEFAULT_FONT )

    self:SetChip( 0 )
    self:SetArcadeNumber( 0 )

    self.m_ac_prosperous_money = cc.CSLoader:createTimeline( GOLD_INGOT_CSB_FILE1 )
    self.m_n_prosperous_money:runAction( self.m_ac_prosperous_money )
    -- self.m_ac_prosperous_money:play( "Main", true )

    self:setVisible( false )
end

function NavigationView:RegisterEvent()
    print("NavigationView:RegisterEvent")

    local function eventHander( event )
        if event:getEventName() == tostring( cc.exports.define.EVENTS.LOGIN ) then
            self:OnLogin()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.LOGOUT ) then
            self:OnLogout()
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.CHIP_UPDATE ) then
            print("eventHander " .. cc.exports.define.EVENTS.CHIP_UPDATE .. " ", event._usedata)
            self:SetChip( event._usedata )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.SET_ARCADE_NO ) then
            self:SetArcadeNumber( event._usedata )
        end
    end

    for i, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function NavigationView:OnLogin()
    self:setVisible( true )
end

function NavigationView:OnLogout()
    self:setVisible( false )
    self:SetChip( 0 )
    self:SetArcadeNumber( 0 )
end

function NavigationView:OnClickedInfoBtn( event )
    if event.name == "ended" then
        self.m_sp_info:setVisible( not self.m_sp_info:isVisible() )
    end
end

function NavigationView:OnClickedBackBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.LOGOUT )
    end
end

function NavigationView:SetArcadeNumber( number )
    self.m_txt_arcade:setString( string.format("NO.%03d", number ) )
end

function NavigationView:SetChip( number )
    number = math.floor( number )
    self.m_txt_redDiamond:setString( string.formatnumberthousands( number ) )
end

return NavigationView
