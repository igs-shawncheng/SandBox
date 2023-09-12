
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

local MIN_ZORDER = 0
local curZorder = MIN_ZORDER
local function GetZorder()
    curZorder = curZorder + 1
    return curZorder
end

local ZOrder = {
    GAME = MIN_ZORDER,
    FREE_SPIN_CARD = GetZorder(),
    NAVIGATION = GetZorder(),
    LOGIN = GetZorder(),
    MESSAGE_BOX = GetZorder(),
}

function MainScene:onCreate()
    print("MainScene:onCreate")
    -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)

    local sceneY = (display.height - CC_DESIGN_RESOLUTION.height) / 2
    local sceneX = (display.width - CC_DESIGN_RESOLUTION.width) / 2
    self:setPosition( cc.p( sceneX, sceneY ) )

    local view = self:getApp():createView( "NavigationView" )
    view:setPosition( cc.p( 0, 496 ) )
    self:addChild( view, ZOrder.NAVIGATION )

    local view = self:getApp():createView( "GameView" )
    self:addChild( view, ZOrder.GAME )

    local view = self:getApp():createView( "LoginView" )
    self:addChild( view, ZOrder.LOGIN )

    local view = self:getApp():createView( "MessageBoxView" )
    self:addChild( view, ZOrder.MESSAGE_BOX )

    local view = self:getApp():createView( "FreeSpinCardView" )
    self:addChild( view, ZOrder.FREE_SPIN_CARD )
end

return MainScene
