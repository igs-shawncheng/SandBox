require("luasocket.socket")
local Connection = class("Connection")

--[[
    使用luasocket實作的連線層
    HandleSocketIOLoop需要從外部trigger
]]

function Connection:ctor(socketCallback)
    self._socketCallBack = socketCallback
    --self:_socketCallBack(1234)
    self._isConnected = false
    self._sendPacketQueue = {}
end

function Connection:Connect(ip, port)
    self._ip = ip
    self._port = port
    self._socket = socket.tcp()  -- socket 協定
    self._socket:settimeout(0) -- 非阻塞
    self._socket:setoption("tcp-nodelay", true) -- 去掉優化
    self._socket:connect(self._ip, self._port) -- 連線
end

function Connection:IsConnected()
    local forWrite = {}
    table.insert(forWrite, self._socket)
    local readyForWrite
    _, readyForWrite, _ = socket.select(nil, forWrite, 0)
    if #readyForWrite > 0 then
        self._isConnected = true
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
    table.insert(self._sendPacketQueue, 1, jsonStr)
end

--[[
    update socket loop by external
]]
function Connection:HandleSocketIOLoop()
    if not self._isConnected then
        return
    end
    self:HandleReceivePacket()
    self:HandleSendPacket()
end

function Connection:Close()
    self._socket:Close()
    self._isConnected = false
end

--[[
    private 處理接收任務
]]
function Connection:HandleReceivePacket()
    --檢查有無socket
    local recvt, sendt, status = socket.select({self._socket}, nil, 0)
    print("Connection:HandleReceivePacket = ", #recvt, sendt, status)
    if #recvt <= 0 then
        return
    end
    local buffer = self._socket:receive(0)
    self._socketCallBack(buffer)
end

--[[
    private 處理發送任務  
]]
function Connection:HandleSendPacket()
    if self.Packet and #self._sendPacketQueue > 0 then
        local data = self._sendPacketQueue[#self._sendPacketQueue]
        print("Connection:HandleSendPacket data:", data)
        if data then
            local _len, _error = self._socket:send(data)
            if _len ~= nil and _len == #data then
                table.remove(self._sendPacketQueue, #self._sendPacketQueue)
            else

            end
        end
    end
end

cc.Connection = Connection
return Connection