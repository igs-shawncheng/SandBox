require ("app.network.NetService")
require ("app.message.PACHIN_U2G_GAME_INFO_REQ")
require ("app.message.SLOT_G2U_GAME_INFO_ACK")
require ("app.message.Protocol")

local SubSystemBase = class("SubSystemBase")
local RegisteOnCommand = {}
function SubSystemBase:ctor()
    self:Init()
end

function SubSystemBase:GetInstance()
    if not self.instance then
        self.instance = SubSystemBase:create()
    end
    return self.instance
end

function SubSystemBase:Init()
    if self.isInit then
        return
    end
    self.isInit = true
    self.netService = cc.NetService:create(self)
end

function SubSystemBase:Login(ip, port)
    self.netService:Connect(ip, port)
end

function SubSystemBase:Send(commandType, content) 
    self.netService:Send(commandType, content)
end

function SubSystemBase:Registers(commandType, OnCommand)
    if not RegisteOnCommand[commandType] then
        RegisteOnCommand[commandType] = {}
    end
    local onCommandList = RegisteOnCommand[commandType]
    for i, registeredFunc  in ipairs(onCommandList) do
        if registeredFunc  == OnCommand then
            print("SubSystemBase Registers duplicate commandType:", commandType)
            return
        end
    end
    print("Registers", commandType, self)
    table.insert(RegisteOnCommand[commandType], OnCommand)
end

function SubSystemBase:Unregisters(commandType, OnCommand)
    if not RegisteOnCommand[commandType] then
        print("SubSystemBase Registers unregisters fail! It doesn't exist commandType:", commandType)
        return
    end
    for i, registeredFunc  in ipairs(RegisteOnCommand[commandType]) do
        if registeredFunc  == OnCommand then
            table.remove(RegisteOnCommand[commandType], i)
            return
        end
    end
end

function SubSystemBase:CallRegisterCommand(command)
    if not RegisteOnCommand[command.commandType] then
        print("SubSystemBase CallRegisterCommand fail! It doesn't exist commandType:", command.commandType)
        return
    end

    for index, value in ipairs(RegisteOnCommand[command.commandType]) do
        value(self, command)
    end
end

function SubSystemBase:OnCommand(command)
    print("SubSystemBase Recv Command:", command.commandType)
    --local recvCommand = command.commandType
    self:CallRegisterCommand(command)
    -- if recvCommand == ServerCommand.SLOT_G2U_GAME_INFO_ACK then
    --     local response = cc.SLOT_G2U_GAME_INFO_ACK:create(command.content)
    --     cc.exports.dispatchEvent( cc.exports.define.EVENTS.NET_LOGIN_SUCCESS )
    -- elseif recvCommand == ServerCommand.SLOT_G2U_SPIN_ACK then
    --     print("Recv Command 2")
    -- elseif recvCommand == ServerCommand.SLOT_G2U_BONUS_SPIN_ACK then
    --     print("Recv Command 4")
    -- elseif recvCommand == ServerCommand.SLOT_G2U_GET_BONUS_RECORD_ACK then
    --     print("Recv Command 6")
    -- elseif recvCommand == ServerCommand.SLOT_G2U_BONUS_RECORD_NOTIFY then
    --     print("Recv Command 7")
    -- end
end

cc.SubSystemBase = SubSystemBase
return SubSystemBase