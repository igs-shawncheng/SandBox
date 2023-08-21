require "app.serialization.JsonDeserialize"
local CommandRecv = class("CommandRecv", cc.JsonDeserialize:create())

function CommandRecv:ctor(content)
    self:Deserialize(content)
    --     self.commandType = {}
    --     self.content 
end

cc.CommandRecv = CommandRecv