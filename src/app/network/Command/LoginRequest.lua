require "cocos.cocos2d.json"
local LoginRequest = class("LoginRequest", cc.Command:create(cc.Protocol.PachinU2GProtocol.PACHIN_U2G_LOGIN_REQ))

function LoginRequest:ctor(accountId, roomId)
    local metatable = getmetatable(self)
    metatable.__newindex = function (t, k, v)
        if k == "content" then
            self.data.content = v
        end
    end

    local requestData = {}
    requestData.loginData = {}
    requestData.loginData.accountId = accountId
    requestData.loginData.roomIndex = roomId

    local success, jsonStr = pcall(json.encode, requestData)
    self.content = jsonStr
    --self.Serialize(self)
end

cc.LoginRequest = LoginRequest
return LoginRequest