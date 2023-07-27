local FiniteState = class( "FiniteState" ) 
FiniteState.__index = FiniteState

FiniteState.m_initialState = nil

FiniteState.m_currentState = nil
FiniteState.m_nextState = nil

FiniteState.m_toTransit = false
FiniteState.m_entering = false

FiniteState.m_transitTime = 0

function FiniteState:extend( target )
	setmetatable( target, FiniteState )
	return target
end

function FiniteState:Init( initState )
	self.m_initialState = initState

	self.m_currentState = self.m_initialState
	self.m_nextState = self.m_initialState

	self.m_toTransit = true
	self.m_entering = false

	self.m_transitTime = cc.exports.getTickSecond()
end

function FiniteState:Transit( newState )
	self.m_nextState = newState
	self.m_toTransit = true
end

function FiniteState:Tick()
	if self.m_toTransit then
		self.m_currentState = self.m_nextState
		self.m_toTransit = false
		self.m_entering = true
		self.m_transitTime = cc.exports.getTickSecond()
	else
		self.m_entering = false
	end

	return self.m_currentState
end

function FiniteState:IsEntering()
	return self.m_entering
end

function FiniteState:Current()
	return self.m_currentState
end

--[[
	單位是秒(s)
--]]
function FiniteState:Elapsed()
	return cc.exports.getTickSecond() - self.m_transitTime
end

function FiniteState:create( initState )
	if not tonumber( initState ) then
		printError( "initState is not nubmer, initState:", initState )
		return
	end

	local FS = FiniteState:extend( {} )
	FS:Init( initState )
	return FS
end

cc.exports.FiniteState = FiniteState