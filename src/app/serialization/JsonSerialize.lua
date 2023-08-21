require "cocos.cocos2d.json"
local JsonSerialize = class("JsonSerialize")

function JsonSerialize:ctor()
end

function JsonSerialize:Serialize()
    --dump(self)
    local data = {}
    for key, value in pairs(self) do
        if key ~= "class" then
            data[key] = value
        end
        --print("Serialize:", key)
    end
    local success, jsonStr = pcall(json.encode, data)
    --print("JsonSerialize:", success, jsonStr)
    if success then
        return jsonStr
    end
end

cc.JsonSerialize = JsonSerialize