require "app.message.JsonSerialize"

local CommandSend = class("CommandSend", cc.JsonSerialize:create())

function CommandSend:ctor(commandType, content)
    self.commandType = commandType
    self.content = content
end

cc.CommandSend = CommandSend