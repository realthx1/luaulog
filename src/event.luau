--!optimize 2
--!native

local LogLevel = require "./level"

local mod = {}

export type LogContext = { Source: string?, Name: string?, Line: number?, Trace: string? }

export type LogEvent = {
	LogLevel: LogLevel.Enum,
	Timestamp: number,
	Context: LogContext?,
	Args: { unknown },
	Prefixes: { string },
	Postfixes: { string },
}

local function new(level: LogLevel.Enum, args: { unknown }, context: LogContext?): LogEvent
	local event: LogEvent = {
		LogLevel = level,
		Timestamp = os.time() + os.clock() % 1,
		Context = context,
		Args = args,
		Prefixes = {},
		Postfixes = {},
	}
	return event
end

mod.new = new

return mod
