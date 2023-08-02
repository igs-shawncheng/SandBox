
local NavigationView = class("NavigationView", cc.load("mvc").ViewBase)

NavigationView.RESOURCE_FILENAME = "Platform/navigation/Navigation.csb"
NavigationView.RESOURCE_BINDING = {
    ["txt_redDiamond"] = {
        ["varname"] = "m_txt_redDiamond"
    },
    ["txt_arcade"] = {
        ["varname"] = "m_txt_arcade"
    },
    ["btn_menu"] = {
        ["varname"] = "m_btn_menu",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedMenuBtn"
            }
        }
    },
    ["sp_menu"] = {
        ["varname"] = "m_sp_menu"
    },
    ["n_prosperous_money"] = {
        ["varname"] = "m_n_prosperous_money"
    },
    ["btn_back"] = {
        ["varname"] = "m_btn_back",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedBackBtn"
            }
        }
    },
    ["btn_mall_game"] = {
        ["varname"] = "m_btn_mall_game",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedMallBtn"
            }
        }
    },
    ["btn_gameStatus"] = {
        ["varname"] = "m_btn_gameStatus",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedGameStatusBtn"
            }
        }
    },
    ["btn_info"] = {
        ["varname"] = "m_btn_info",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedInfoBtn"
            }
        }
    },
    ["btn_item"] = {
        ["varname"] = "m_btn_item",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedItemBtn"
            }
        }
    },
    ["btn_music"] = {
        ["varname"] = "m_btn_music",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedMusicBtn"
            }
        }
    },
    ["btn_input"] = {
        ["varname"] = "m_btn_input",
        ["events"] = {
            {
                event = "touch",
                method = "OnClickedInputBtn"
            }
        }
    },
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.LOGIN,
    cc.exports.define.EVENTS.LOGOUT,
    cc.exports.define.EVENTS.CHIP_UPDATE,
    cc.exports.define.EVENTS.SET_ARCADE_NO,
    cc.exports.define.EVENTS.MUTE_SETTING_CHANGED,
    cc.exports.define.EVENTS.IO_SETTING_CHANGED,
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
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.MUTE_SETTING_CHANGED ) then
            self:OnMuteSettingChanged( event._usedata )
        elseif event:getEventName() == tostring( cc.exports.define.EVENTS.IO_SETTING_CHANGED ) then
            self:OnIOSettingChanged( event._usedata )
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

function NavigationView:OnEnter()
    print("NavigationView:OnEnter()")
    
    self.m_sp_menu:setVisible( false )
end

function NavigationView:OnClickedMenuBtn( event )
    if event.name == "ended" then
        self.m_sp_menu:setVisible( not self.m_sp_menu:isVisible() )
    end
end

function NavigationView:OnClickedBackBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.CLICKED_BACK_BTN )
    end
end

function NavigationView:OnClickedMallBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.CLICKED_MALL_BTN )
    end
end

function NavigationView:OnClickedGameStatusBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.CLICKED_GAME_STATUS_BTN )
    end
end

function NavigationView:OnClickedInfoBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.CLICKED_INFO_BTN )
    end
end

function NavigationView:OnClickedItemBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.CLICKED_ITEM_BTN )
    end
end

function NavigationView:OnClickedMusicBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.CLICKED_MUSIC_BTN )
    end
end

function NavigationView:OnClickedInputBtn( event )
    if event.name == "ended" then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.CLICKED_INPUT_BTN )
    end
end

function NavigationView:SetArcadeNumber( number )
    self.m_txt_arcade:setString( string.format("NO.%03d", number ) )
end

function NavigationView:SetChip( number )
    number = math.floor( number )
    self.m_txt_redDiamond:setString( string.formatnumberthousands( number ) )
end

function NavigationView:OnMuteSettingChanged( isMute )
    local text = "音樂:On"
    if isMute then
        text = "音樂:Off"
    end
    self.m_btn_music:setTitleText( text )
end

function NavigationView:OnIOSettingChanged( isActive )
    local text = "IO:Off"
    if isActive then
        text = "IO:On"
    end
    self.m_btn_input:setTitleText( text )
end

return NavigationView
