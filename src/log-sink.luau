--!optimize 2
--!native

local logevent = require "./log-event"
local LogLevel = require "./log-level"

local mod = {}

export type LogSink = setmetatable<{
	minLogLevel: LogLevel.LogLevel,

	Emit: (self: LogSink, logevent.LogEvent) -> (),
}, { __index: typeof(mod) }>

local function raw(callback: (self: LogSink, logevent.LogEvent) -> ()): LogSink
	local logsink: LogSink = setmetatable({
		minLogLevel = LogLevel.Verbose,
		Emit = callback,
	}, { __index = mod })

	return logsink
end
local function new(emitFn: (self: LogSink, logevent.LogEvent) -> ()): LogSink
	return raw(function(self: LogSink, event: logevent.LogEvent)
		if self.minLogLevel > event.LogLevel then return end
		emitFn(self, event)
	end)
end

local function setMinLevel(self: LogSink, minLevel: LogLevel.LogLevel): LogSink
	self.minLogLevel = minLevel
	return self
end

mod.setMinLevel = setMinLevel

mod.raw = raw
mod.new = new

return mod
