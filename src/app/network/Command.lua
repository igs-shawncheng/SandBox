require "cocos.cocos2d.json"

local Command = class("Command")

function Command:ctor(commandType, content)
    self.data = {}
    self.data.commandType = commandType
    if content == nil then
        self.data.content = ""
    else
        self.data.content = content
    end
end

function Command:Serialize()
    local success, jsonStr = pcall(json.encode, self.data)
    if not success then
        print("Command ToJson Error data:", self.data)
    end
    print("Command ToJson Result:", jsonStr)
    return jsonStr
end

function Command:DeSerialize(buffer)
    local success, command = pcall(json.decode, buffer)
    if not success then
        print("Command ToCommand Error data:", buffer)
        return false
    end
    dump(command)
    self.data.commandType = command.commandType
    self.data.content = command.content
    return true
end

function Command:CommandType()
    return self.data.commandType
end

function Command:Con()
    return self.data.content
end


cc.Command = Command
return Command