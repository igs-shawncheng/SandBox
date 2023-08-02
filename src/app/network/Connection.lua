require("luasocket.socket")
local Connection = class("Connection")

function Connection:ctor()
    self._isConnected = false
    self._sendTaskQueue = {}
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
        return true
    end
    return false
end

--[[
    update socket loop by external
]]
function Connection:DisposeTCPIO()
    if not self._isConnected then
        return
    end
    self:DisposeReceiveTask()
    self:DisposeSendTask()
end

--[[
    處理接收任務
]]
function Connection:DisposeReceiveTask()
    --檢查有無socket
    local recvt, sendt, status = socket.select({self._socket}, nil, 0)
    print("[NetMgr:disposeReceiveTask] = ", #recvt, sendt, status)
    if #recvt <= 0 then
        return
    end
    local buffer = self._socket:receive(0)
     

end

--[[
    處理發送任務  
]]
function Connection:DisposeSendTask()
    if self._sendTaskQueue and #self._sendTaskQueue > 0 then
        local data = self._sendTaskQueue[#self._sendTaskQueue]
        if data then
            local _len, _error = self._socket:send(data)
            if _len ~= nil and _len == #data then
                table.remove(self._sendTaskQueue, #self._sendTaskQueue)
            else

            end
        end
    end
end
--[[
    發送任務
    @param: commandType
    @param: content
]]
function Connection:Send(jsonStr)
    table.insert(self._sendTaskQueue, 1, jsonStr)
end

cc.Connection = Connection
return Connection