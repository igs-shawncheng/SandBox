
local AppBase = class("AppBase")

function AppBase:ctor(configs)
    self.configs_ = {
        viewsRoot  = "app.views",
        modelsRoot = "app.models",
        defaultSceneName = "MainScene",
    }

    for k, v in pairs(configs or {}) do
        self.configs_[k] = v
    end

    if type(self.configs_.viewsRoot) ~= "table" then
        self.configs_.viewsRoot = {self.configs_.viewsRoot}
    end
    if type(self.configs_.modelsRoot) ~= "table" then
        self.configs_.modelsRoot = {self.configs_.modelsRoot}
    end

    if DEBUG > 1 then
        dump(self.configs_, "AppBase configs")
    end

    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end

    -- event
    self:onCreate()
end

function AppBase:run(initSceneName)
    initSceneName = initSceneName or self.configs_.defaultSceneName
    self:enterScene(initSceneName)
end

function AppBase:enterScene(sceneName, transition, time, more)
    local view = self:createView(sceneName)
    view:showWithScene(transition, time, more)
    return view
end

function AppBase:createView(name)
    for _, root in ipairs(self.configs_.viewsRoot) do
        local packageName = string.format("%s.%s", root, name)
        local status, view = xpcall(function()
                return require(packageName)
            end, function(msg)
            if not string.find(msg, string.format("'%s' not found:", packageName)) then
                print("load view error: ", msg)
            end
        end)
        local t = type(view)
        if status and (t == "table" or t == "userdata") then
            local v = view:create(self, name)
            self:registerHandler( v )
            return v
        end
    end
    error(string.format("AppBase:createView() - not found view \"%s\" in search paths \"%s\"",
        name, table.concat(self.configs_.viewsRoot, ",")), 0)
end

function AppBase:onCreate()
end

function AppBase:registerHandler( target )
    if type( target.OnEnter ) == "function" 
        or type( target.OnExit ) == "function" 
        or type( target.OnUpdate ) == "function"  then

        local function OnScriptEvent( event )
            if event == "enter" then
                if type( target.OnEnter ) == "function" then
                    target:OnEnter()
                end
                if type( target.OnUpdate ) == "function"  then
                    local function OnUpdate( dt )
                       target:OnUpdate( dt )
                    end

                    target:scheduleUpdateWithPriorityLua( OnUpdate, 0 )
                end
            elseif event == "exit" then
                if type( target.OnExit ) == "function" then
                    target:OnExit()
                end
                if type( target.OnUpdate ) == "function"  then
                    target:unscheduleUpdate()
                end
            end
        end
        target:registerScriptHandler( OnScriptEvent )
    end
end

return AppBase
