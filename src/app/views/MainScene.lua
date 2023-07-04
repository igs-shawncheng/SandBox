
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)

    local testInt = Inanna.GetJoyTube().m_testInt
    print("Inanna.GetJoyTube().m_testInt", testInt)

    -- input
    local layer = cc.LayerColor:create( cc.c3b( 0, 0, 0 ), display.width, display.height )
    layer:move(display.left_bottom)
    layer:addTo(self)

    layer:onTouch( function( event )
        print("layer onTouch x:" .. event.x .. " y:" .. event.y)

        Inanna.GetJoyTube():OnTouch( event.x, event.y )
    end )

    -- init
    local layerInit = cc.LayerColor:create( cc.c3b( 150, 150, 150 ), display.width, display.height )
    layerInit:setTouchEnabled( true )
    layerInit:move(display.left_bottom)
    layerInit:addTo(self)

    local hintLabel = cc.Label:createWithSystemFont("Click To Init", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(layerInit)

    layerInit:onTouch( function( event )
        Inanna.GetJoyTube():Init()
        layerInit:removeSelf()
        layer:setTouchEnabled( true )
    end )
end

return MainScene
