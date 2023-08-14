require "cocos.cocos2d.json"
local ISerialize = class("ISerialize")

function ISerialize:ctor()
end

function ISerialize:Serialize()
    --dump(self)
    local data = {}
    for key, value in pairs(self) do
        if key ~= "class" then
            data[key] = value
        end
        --print("Serialize:", key)
    end
    local success, jsonStr = pcall(json.encode, data)
    --print("ISerialize:", success, jsonStr)
    if success then
        return jsonStr
    end
end

cc.ISerialize = ISerialize