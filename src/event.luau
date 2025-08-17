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
	Message: number?,
	LogLevel: LogLevel.Enum,
	Context: LogContext?,
}

local function new(level: LogLevel.Enum, args: { unknown }, context: LogContext?): LogEvent
	local event: LogEvent = {
		Args = args,
		Timestamp = DateTime.now().UnixTimestampMillis,
		Prefixes = {},
		Postfixes = {},
		Message = nil,
		LogLevel = level,
		Context = context,
	}
	return event
end

mod.new = new

return mod
