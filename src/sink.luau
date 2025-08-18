--!optimize 2
--!native

local logevent = require "./event"
local logfilter = require "./filter"

local mod = {}

export type LogSink = {
	Emit: (logevent.LogEvent) -> (),
	filters: { logfilter.LogFilter },
}

local function new(emitter: (logevent.LogEvent) -> ()): LogSink
	local logsink: LogSink = {
		Emit = emitter,
		filters = {},
	}

	return logsink
end

mod.new = new

return mod
