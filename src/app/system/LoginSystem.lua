require "app.message.PACHIN_G2U_LOGIN_ACK"
require "app.message.PACHIN_G2U_ROOM_INFO_ACK"
require "app.message.PACHIN_G2U_JOIN_ROOM_ACK"
require "app.message.PACHIN_U2G_LOGIN_REQ"
require "app.message.PACHIN_U2G_ROOM_INFO_REQ"
require "app.message.PACHIN_U2G_JOIN_ROOM_REQ"
require "app.message.PACHIN_U2G_LEAVE_ROOM_REQ"
require "app.message.PACHIN_U2G_GAME_INFO_REQ"

local LoginSystem = class("LoginSystem", cc.SubSystemBase:GetInstance())
local RecvCommand = cc.Protocol.PachinG2UProtocol

function LoginSystem:ctor()
    print("LoginSystem:ctor")
    self:Registers(RecvCommand.PACHIN_G2U_LOGIN_ACK, handler(self, self.OnRecvLogin))
    self:Registers(RecvCommand.PACHIN_G2U_ROOM_INFO_ACK, handler(self, self.OnRecvRoomInfo))
    self:Registers(RecvCommand.PACHIN_G2U_JOIN_ROOM_ACK, handler(self, self.OnRecvJoinRoom)) 

    --defaultValue
    self.accoundId = 1234
    self.port = "8888"
    self.IP = "192.168.165.191"--教和主機ip
    self.roomIndex = 1
end

function LoginSystem:Connect(ip, port, accountID, roomIndex)
    self.IP = self:GetDefaultorTextValue(self.IP, ip)
    print("IP and Port:", self.IP .. " ".. self.port)

    self.accoundId = self:GetDefaultorTextValue(self.accoundId, accountID)
    print("AccountId:",  self.accoundId)
    
    self.roomIndex = self:GetDefaultorTextValue(self.roomIndex, roomIndex)
    print("Room NO:",  self.roomIndex)

    self:GetInstance():Connect(self.IP, self.port, handler(self, self.OnConnected))
end

function LoginSystem:GetDefaultorTextValue(defaultValue, textValue)
    local numberValue = tonumber(textValue)
    if numberValue ~= nil and type( numberValue ) == "number" then
        defaultValue = numberValue
    end
    return defaultValue
end


function LoginSystem:OnConnected()
    self:RequestLogin(self.accoundId)
end

function LoginSystem:RequestLogin(accountid)
    local request = cc.PACHIN_U2G_LOGIN_REQ:create(accountid)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_LOGIN_REQ, request:Serialize())
end

function LoginSystem:RequestRoomInfo(accountid)
    local request = cc.PACHIN_U2G_ROOM_INFO_REQ:create(accountid)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_ROOM_INFO_REQ, request:Serialize())
end

function LoginSystem:RequestJoinRoom(accountId, roomIndex, roomInfo)

    local reserveRoomIndex = roomInfo.roomIndex
    --新進入的機台與保留機台不一樣
    if roomInfo.reserve == true and self.roomIndex ~= reserveRoomIndex then
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
        {
            title = "SystemInfo",
            content = "reserveRoomNumber: " .. reserveRoomIndex,
            confirmBtnText = "Enter Reserve Room",
            cancelBtnText = "Enter New Room",
            showCloseBtn = true,
            confirmCB = function ()
                print("click confirmCB",reserveRoomIndex)
                self.roomIndex = reserveRoomIndex
                self:RequestJoinRoom(self.accoundId, reserveRoomIndex)
            end,
            cancelCB = function ()
                print("click cancelCB",self.roomIndex)
                self:RequestJoinRoom(self.accoundId, self.roomIndex)
            end,
            closeCB = function ()
                print("click closeCB")
            end,
        } )
        return
    end

    local request = cc.PACHIN_U2G_JOIN_ROOM_REQ:create(accountId, roomIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_JOIN_ROOM_REQ, request:Serialize())
end

function LoginSystem:RequestLeaveRoom(reserve)
    local request = cc.PACHIN_U2G_LEAVE_ROOM_REQ:create(self.accountid, reserve)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_LEAVE_ROOM_REQ, request:Serialize())
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.LEAVEGAME )
end

function LoginSystem:RequestGameInfo(accountId, roomIndex)
    local request = cc.PACHIN_U2G_GAME_INFO_REQ:create(accountId, roomIndex)
    self:GetInstance():Send(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_GAME_INFO_REQ, request:Serialize())
end

function LoginSystem:OnRecvLogin(command)
    print("Recv Command 1")
    local response = cc.PACHIN_G2U_LOGIN_ACK:create(command.content)
    if response.LoginAck.success then
        self:RequestRoomInfo(self.accoundId)
    else
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
        {
            title = "SystemInfo",
            content = "login fail: ",
            confirmCB = function ()
            print("click confirmCB")
        end,
            btnPosType = 1,
        } )
    end
end

function LoginSystem:OnRecvRoomInfo(command)
    print("Recv Command 2")
    local response = cc.PACHIN_G2U_ROOM_INFO_ACK:create(command.content)
    dump(response)

    self:RequestJoinRoom(self.accoundId, self.roomIndex, response.RoomInfoAck)
end

function LoginSystem:OnRecvJoinRoom(command)
    print("Recv Command 3")
    local response = cc.PACHIN_G2U_JOIN_ROOM_ACK:create(command.content)
    dump(response)
    cc.exports.dispatchEvent( cc.exports.define.EVENTS.JOIN_ROOM_ACK, response.JoinRoomAck )

    if response.JoinRoomAck.success then
        self.LoginSystem:RequestGameInfo(self.accoundId,self.roomIndex)
    else
        cc.exports.dispatchEvent( cc.exports.define.EVENTS.SHOW_MSG,
        {
            title = "SystemInfo",
            content = "JoinRoomFail",
            confirmCB = function ()
            print("click confirmCB")
        end,
            btnPosType = 1,
        } )
    end
end

return LoginSystem