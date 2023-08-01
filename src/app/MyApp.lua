
local MyApp = class("MyApp", cc.load("mvc").AppBase)

require("app.Define")
require("app.GlobalFunc")
require("app.FiniteState")
require("app.PluginProgram")

function MyApp:onCreate()
    math.randomseed(os.time())
end

return MyApp
