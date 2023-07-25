
local ViewBase = class("ViewBase", cc.Node)

ViewBase.dom = {}

local function recursionChlidNode(rootNode)
    local children = rootNode:getChildren()
    for _, childNode in ipairs(children or {}) do
        local name = childNode:getName()
        -- print("name ", name)
        ViewBase.dom[name] = childNode
        recursionChlidNode(childNode)
    end
end

function ViewBase:ctor(app, name)
    self:enableNodeEvents()
    self.app_ = app
    self.name_ = name

    -- check CSB resource file
    local res = rawget(self.class, "RESOURCE_FILENAME")
    if res then
        self:createResourceNode(res)
    end

    local binding = rawget(self.class, "RESOURCE_BINDING")
    if res and binding then
        self:createResourceBinding(binding)
    end

    if self.onCreate then self:onCreate() end
end

function ViewBase:getApp()
    return self.app_
end

function ViewBase:getName()
    return self.name_
end

function ViewBase:getResourceNode()
    return self.resourceNode_
end

function ViewBase:createResourceNode(resourceFilename)
    if self.resourceNode_ then
        self.resourceNode_:removeSelf()
        self.resourceNode_ = nil
    end
    self.resourceNode_ = cc.CSLoader:createNode(resourceFilename)
    assert(self.resourceNode_, string.format("ViewBase:createResourceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    self:addChild(self.resourceNode_)
end

-- function ViewBase:createResourceBinding(binding)
--     assert(self.resourceNode_, "ViewBase:createResourceBinding() - not load resource node")
--     for nodeName, nodeBinding in pairs(binding) do
--         local node = self.resourceNode_:getChildByName(nodeName)
--         if nodeBinding.varname then
--             self[nodeBinding.varname] = node
--         end
--         for _, event in ipairs(nodeBinding.events or {}) do
--             if event.event == "touch" then
--                 node:onTouch(handler(self, self[event.method]))
--             end
--         end
--     end
-- end

function ViewBase:createResourceBinding(binding)
    assert(self.resourceNode_, "ViewBase:createResourceBinding() - not load resource node")
    recursionChlidNode(self.resourceNode_)
    for bindWidgetName, ruleTable in pairs(binding) do
        for widgetName, node in pairs(ViewBase.dom) do
            -- print(widgetName,tolua.type(node))
            if ruleTable.varname and widgetName == bindWidgetName then
                self[ruleTable.varname] = node
                for _, event in ipairs(ruleTable.events or {}) do
                    if event.event == "touch" then
                        node:onTouch(handler(self, self[event.method]))
                    end
                end
            end
        end
    end
end

function ViewBase:showWithScene(transition, time, more)
    self:setVisible(true)
    local scene = display.newScene(self.name_)
    scene:addChild(self)
    display.runScene(scene, transition, time, more)
    return self
end

return ViewBase
