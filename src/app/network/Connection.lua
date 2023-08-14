require "cocos.cocos2d.json"
require("luasocket.socket")
local Connection = class("Connection")

--[[
    使用luasocket實作的連線層
    HandleSocketIOLoop需要從外部trigger
]]

function Connection:ctor(socketCallback)
    self.socketCallBack = socketCallback
    self.isConnected = false
    self.sendPacketQueue = {}
end

function Connection:Connect(ip, port)
    self.ip = ip
    self.port = port
    self.socket = socket.tcp()  -- socket 協定
    self.socket:settimeout(0) -- 非阻塞
    self.socket:setoption("tcp-nodelay", true) -- 去掉優化
    self.socket:connect(self.ip, self.port) -- 連線
end

function Connection:IsConnected()
    local forWrite = {}
    table.insert(forWrite, self.socket)
    local readyForWrite
    _, readyForWrite, _ = socket.select(nil, forWrite, 0)
    if #readyForWrite > 0 then
        self.isConnected = true
        return true
    end
    return false
end

--[[
    發送任務
    @param: commandType
    @param: content
]]
function Connection:Send(jsonStr)
    print("Connection:Send", jsonStr)
    table.insert(self.sendPacketQueue, 1, jsonStr)
end

--[[
    update socket loop by external
]]
function Connection:HandleSocketIOLoop()
    if not self.isConnected then
        return
    end
    self:HandleReceivePacket()
    self:HandleSendPacket()
end

function Connection:Close()
    self.socket:close()
    self.isConnected = false
    print("Close Connection")
end

--[[
    private 處理接收任務
]]
function Connection:HandleReceivePacket()
    --檢查有無socket timeout 1
    local recvt, sendt, status = socket.select({self.socket}, nil, 1)
    
    if #recvt <= 0 then
        return
    end  
    print("Connection:HandleReceivePacket = ", #recvt, sendt, status)
    --開始接收資料
    local buffer = {}
    local data, receiveStatus, partial
    while true do
        --不知道長度，所以一次讀一個byte
        data, receiveStatus, partial = self.socket:receive(1)
        print("Connection:data:", data, receiveStatus, partial)
        if data then
            table.insert(buffer, data)
        else
            recvt, sendt, status = socket.select({self.socket}, nil, 1)
            --讀取完畢脫離
            if receiveStatus == "closed" or receiveStatus == "timeout" then
                break
            end

            if receiveStatus ~= "timeout" then
                print("Error receiving data:", data, receiveStatus)
                break
            end
        end
    end

    if #buffer == 0 then
        --收到空封包，經測試應為server主動close socket
        if receiveStatus == "closed" then
            self:Close() 
        end

        return
    end

    --print("Buffer", table.concat(buffer))
    if self.socketCallBack then
        self.socketCallBack(table.concat(buffer))
    end
end

--[[
    private 處理發送任務  
]]
function Connection:HandleSendPacket()
    if self.sendPacketQueue and #self.sendPacketQueue > 0 then
        local data = self.sendPacketQueue[#self.sendPacketQueue]
        if data then
            local len, error = self.socket:send(data)
            print("Connection:HandleSendPacket data:", data)
            if len ~= nil and len == #data then
                table.remove(self.sendPacketQueue, #self.sendPacketQueue)
            else

            end
        end
    end
end

cc.Connection = Connection
return Connection
