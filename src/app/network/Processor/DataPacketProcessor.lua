require "cocos.cocos2d.json"

local DataPacketProcessor = class("DataPacketProcessor")

function DataPacketProcessor:ctor()
    self.canReceive = false
    self.dataPacketList = {}
end

function DataPacketProcessor:splitDataPacket(content, splitSize) 
    local splitPacket = {}
    local index = 1

    while index <= #content do
        local fragment = string.sub(content, index, index + splitSize - 1)
        index = index + splitSize
        table.insert(splitPacket, fragment)
    end

    return splitPacket
end

function DataPacketProcessor:combineDataPacket()
    local combinedPacket = {}
    local command = {}
    
    for _, value in ipairs(self.dataPacketList) do
        table.insert(combinedPacket, value)
    end
    local finalPacket = ""
    for key, value in ipairs(combinedPacket) do
        finalPacket = finalPacket .. value
    end
    local startTag = "*split"
    local endTag = "*end"
    local commandType = string.match(finalPacket, "(.-)" .. startTag)
    local content = string.match(finalPacket, startTag .. "(.+)" .. endTag)

    local success, decommand = pcall(json.decode, commandType)
    if success then
        command["commandType"] = decommand.commandType
    else
        print("Json DeSerialize fail!")
    end
    command["content"] = content
    return command
end

function DataPacketProcessor:receiveDataPacket(content)
    table.insert(self.dataPacketList, content)
end

function DataPacketProcessor:isReceiveEnd(content)
    if string.find(content, "*end") == nil then
        print("Packet is receiving")
        return false
    else
        print("receive finish")
        return true
    end
end

function DataPacketProcessor:clear()
    self.dataPacketList = {}
end

function DataPacketProcessor:PreProcessSend(commandType, content, connection)
    local splitContent = self:splitDataPacket(content, cc.exports.define.SPLIT_DATA_PACKET_SIZE)
    local command = {}
    command["commandType"] = commandType
    local success, commandTypeCombin = pcall(json.encode, command)
    if success then
        commandTypeCombin = commandTypeCombin .. "*split"
    else
        print("Json Serialize fail!")
    end
    connection:Send(commandTypeCombin)
    local split = ""
    for i = 1, #splitContent, 1 do
        split = splitContent[i]
        if i == #splitContent then
            split = split .. "*end"
        end
        connection:Send(split)
    end
end

function DataPacketProcessor:PreProcessRecv(deCommand, canReceive)
    self.canReceive = false
    self:receiveDataPacket(deCommand.content)
    if self:isReceiveEnd(deCommand.content) then
        local finalContent = self:combineDataPacket()
        deCommand.content = finalContent.content
        deCommand.commandType = finalContent.commandType
        self:clear()
        self.canReceive = true
    end

    return deCommand, self.canReceive
end

cc.DataPacketProcessor = DataPacketProcessor
return DataPacketProcessor
