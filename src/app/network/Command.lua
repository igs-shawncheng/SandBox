require "app.network.Command.ISerialize"

local Command = class("Command", cc.ISerialize:create())

function Command:ctor(commandType, content)
    self.commandType = commandType
    self.content = content
end

-- function Command:Serialize()
--     local success, jsonStr = pcall(json.encode, self.data)
--     if not success then
--         print("Command ToJson Error data:", self.data)
--     end
--     print("Command ToJson Result:", jsonStr)
--     return jsonStr
-- end

-- function Command:DeSerialize(buffer)
--     local success, result = pcall(json.decode, buffer)
--     if not success then
--         print("Command ToCommand Error data:", buffer)
--         return false
--     end

--     self.data.commandType = result.commandType
--     self.data.content = result.content
--     return true
-- end

-- function Command:GetType()
--     return self.data.commandType
-- end

-- function Command:GetContent()
--     return self.data.content
-- end


cc.Command = Command