
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"
MainScene.RESOURCE_BINDING = {
    ["btn_Init"] = {
        ["varname"] = "m_btn_init",
        ["events"] = {
            {
                event = "touch",
                method ="onClickedInitBtn"
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

function MainScene:onClickedInitBtn( event )
    -- dump( event, "MainScene:onClickedInitBtn event", 10 )
    if event.name == "ended" then
        self:Init()
    end
end

function MainScene:Init()
    -- input
    local layer = cc.LayerColor:create( cc.c4b( 0, 0, 0, 0 ), display.width, display.height )
    layer:move(display.left_bottom)
    layer:addTo(self.m_joyTubeInput)

    layer:onTouch( function( event )
        print("layer onTouch x:" .. event.x .. " y:" .. event.y)

        Inanna.GetJoyTube():OnTouch( event.x, event.y )
    end )

    -- output
    Inanna.GetJoyTube():Init( self.m_joyTubeOutput )
end

function MainScene:onCreate()
    print("MainScene:onCreate")
    -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)

    local testInt = Inanna.GetJoyTube().m_testInt
    print("Inanna.GetJoyTube().m_testInt", testInt)
end

return MainScene
