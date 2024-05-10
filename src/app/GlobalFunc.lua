local function dispatchEvent( eventString, data )
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	local event = cc.EventCustom:new( eventString )
	event._usedata = data
	dispatcher:dispatchEvent( event )
end

local function getTickSecond()
	return os.time(os.date("!*t"))
end

function Switch( case, cases, default )
	local c = cases[case]
	if c then
		return c()
	elseif type( default ) == "function" then
		return default()
	end
end

cc.exports.getTickSecond = getTickSecond
cc.exports.dispatchEvent = dispatchEvent