
cc.FileUtils:getInstance():setPopupNotify(false)


require "config"
require "cocos.init"
require "app.system.SubSystemBase"


local function main()
    require("app.MyApp"):create():run()
    require ("app.system.SandBoxSystem"):create()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
