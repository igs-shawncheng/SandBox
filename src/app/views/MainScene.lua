local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

local MIN_ZORDER = 0
local curZorder = MIN_ZORDER
local function GetZorder()
    curZorder = curZorder + 1
    return curZorder
end

local VIEWS = {
    Game  = { 
        ZOrder =  MIN_ZORDER,
        NAME = "GameView", 
    },
    Lobby  = { 
        ZOrder =  GetZorder(),
        NAME = "LobbyView",
    },
    FreeSpinCard  = { 
        ZOrder =  GetZorder(),
        NAME = "FreeSpinCardView",
    },
    Navigation  = { 
        ZOrder =  GetZorder(),
        NAME = "NavigationView",
        POSITION =  cc.p( 0, 496 )
    },
    Login  = { 
        ZOrder =  GetZorder(),
        NAME = "LoginView",
    },
    MessageBox  = { 
        ZOrder =  GetZorder(),
        NAME = "MessageBoxView",
    },
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

    for _, value in pairs(VIEWS) do
        local view = self:getApp():createView( value.NAME )
        self:addChild( view, value.ZOrder )
        if value.POSITION then view:setPosition( value.POSITION ) end
    end
end

return MainScene