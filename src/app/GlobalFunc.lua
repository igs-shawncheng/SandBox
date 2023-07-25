local function dispatchEvent( eventString, data )
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	local event = cc.EventCustom:new( eventString )
	event._usedata = data
	dispatcher:dispatchEvent( event )
end

cc.exports.dispatchEvent = dispatchEvent