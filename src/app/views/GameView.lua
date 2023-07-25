
local GameView = class("GameView", cc.load("mvc").ViewBase)

GameView.RESOURCE_FILENAME = "Game/GameView.csb"
GameView.RESOURCE_BINDING = {
    ["s_Default"] = {
        ["varname"] = "m_s_Default",
    },
    ["btn_Init"] = {
        ["varname"] = "m_btn_init",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedInitBtn"
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

function GameView:onCreate()
    print("GameView:onCreate")

    local testInt = Inanna.GetJoyTube().m_testInt
    print("Inanna.GetJoyTube().m_testInt", testInt)

    -- test event
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.SET_ARCADE_NO, 1234 )
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.CHIP_UPDATE, 5678 )
end

function GameView:OnEnter()
    print("GameView:OnEnter()")
end

function GameView:OnExit()
    print("GameView:OnExit()")
end

function GameView:OnUpdate( dt )
end

function GameView:OnClickedInitBtn( event )
    -- dump( event, "GameView:OnClickedInitBtn event", 10 )
    if event.name == "ended" then
        self:InitJoyTube()
    end
end

function GameView:InitJoyTube()
    -- input
    local layer = cc.LayerColor:create( cc.c4b( 0, 0, 0, 0 ), CC_DESIGN_RESOLUTION.width, CC_DESIGN_RESOLUTION.height )
    layer:move( display.left_bottom )
    layer:addTo( self.m_joyTubeInput )
    layer:onTouch( function( event )
        print("layer onTouch x:" .. event.x .. " y:" .. event.y)
        local sceneY = (display.height - CC_DESIGN_RESOLUTION.height) / 2
        Inanna.GetJoyTube():OnTouch( event.x, event.y - sceneY )
    end )

    -- output
    Inanna.GetJoyTube():Init( self.m_joyTubeOutput )

    self.m_s_Default:setVisible( false )
    self.m_btn_init:setVisible( false )
end

return GameView
