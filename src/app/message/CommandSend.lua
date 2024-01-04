require "app.serialization.JsonSerialize"

local CommandSend = class("CommandSend", cc.JsonSerialize:create())

function CommandSend:ctor(commandType, content)
    self.commandType = commandType
end

cc.CommandSend = CommandSend