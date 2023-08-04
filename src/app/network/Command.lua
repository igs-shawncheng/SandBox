require "cocos.cocos2d.json"

local Command = class("Command")

function Command:ctor(commandType, content)
    self._data = {}
    self._data.commandType = commandType
    if content == nil then
        self._data.content = ""
    else
        self._data.content = content
    end
end

function Command:Serialize()
    local success, jsonStr = pcall(json.encode, self._data)
    if not success then
        print("Command ToJson Error data:", self._data)
    end
    print("Command ToJson Result:", jsonStr)
    return jsonStr
end

function Command:DeSerialize(buffer)
    local success, command = pcall(json.decode, buffer)
    if not success then
        print("Command ToCommand Error data:", command)
        return false
    end
    print("Command ToCommand Result:", dump(command))
    self._data.commandType = command.commandType
    self._data.content = command.content
    return true
end


cc.Command = Command
return Command