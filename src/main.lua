
cc.FileUtils:getInstance():setPopupNotify(false)


require "config"
require "cocos.init"
require "app.network.NetService"

local function main()
    require("app.MyApp"):create():run()
    cc.NetService:GetInstance():Init()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
