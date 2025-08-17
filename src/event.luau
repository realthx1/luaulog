--!optimize 2
--!native

local LogLevel = require "./level"

local mod = {}

export type LogContext = { source: string?, name: string?, line: number?, trace: string? }

export type LogEvent = {
	Args: { unknown },
	Timestamp: number,
	Prefixes: { string },
	Postfixes: { string },
	LogLevel: LogLevel.Enum,
	Context: LogContext?,
}

local function new(level: LogLevel.Enum, args: { unknown }, context: LogContext?): LogEvent
	local event: LogEvent = {
		Args = args,
		Timestamp = os.time() + os.clock() % 1,
		Prefixes = {},
		Postfixes = {},
		LogLevel = level,
		Context = context,
	}
	return event
end

mod.new = new

return mod
