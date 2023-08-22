require ("app.network.NetService")
require ("app.system.SystemName")

local SubSystemBase = class("SubSystemBase")
local RegisteOnCommand = {}

function SubSystemBase:GetInstance()
    if not self.instance then
        self.instance = SubSystemBase:create()
        self.instance:Init()
    end
    return self.instance
end

function SubSystemBase:Init()
    if self.isInit then
        return
    end
    self.isInit = true
    self.netService = cc.NetService:create(self)
    self.SystemList = {}
    print("SubSystemBase:Init")
    for key, value in pairs(cc.exports.SystemName) do
        table.insert(self.SystemList, value, require("app.system." .. key):create())
    end
end

function SubSystemBase:GetSystem(SystemName)
    dump(self.SystemList)
    --print("SubSystemBase:GetSystem", self.SystemList, SystemName)
    return self.SystemList[SystemName]
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
    --print("Registers", commandType, self)
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
        value(command)
    end
end

function SubSystemBase:OnCommand(command)
    print("SubSystemBase Recv Command:", command.commandType)
    self:CallRegisterCommand(command)
end

cc.SubSystemBase = SubSystemBase
return SubSystemBase