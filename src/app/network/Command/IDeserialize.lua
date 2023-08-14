require "cocos.cocos2d.json"
local IDeserialize = class("IDeserialize")

function IDeserialize:Deserialize(content)
    local success, data = pcall(json.decode, content)
    if success then
        for key, value in pairs(data) do
            print("Deserialize.Result:", key, value)
            self[key] = value
        end
    else
        print("IDeserialize:json DeSerialize fail!", content)
    end
    --dump(data)
end

cc.IDeserialize = IDeserialize