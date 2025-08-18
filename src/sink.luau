--!optimize 2
--!native

local logevent = require "./event"
local logfilter = require "./filter"

local mod = {}

export type LogSink = setmetatable<{
	Emit: (self: LogSink, logevent.LogEvent) -> (),
	filters: { logfilter.LogFilter },
}, { __index: typeof(mod) }>

local function raw(emitter: (self: LogSink, logevent.LogEvent) -> ()): LogSink
	local logsink: LogSink = setmetatable({
		Emit = emitter,
		filters = {},
	}, { __index = mod })

	return logsink
end
local function new(callback: (self: LogSink, logevent.LogEvent) -> ()): LogSink
	return raw(function(self: LogSink, event: logevent.LogEvent)
		callback(self, event)
	end)
end

mod.raw = raw
mod.new = new

return mod
