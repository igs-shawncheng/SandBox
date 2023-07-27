local function dispatchEvent( eventString, data )
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	local event = cc.EventCustom:new( eventString )
	event._usedata = data
	dispatcher:dispatchEvent( event )
end

local function getTickSecond()
	return os.time(os.date("!*t"))
end

cc.exports.getTickSecond = getTickSecond
cc.exports.dispatchEvent = dispatchEvent