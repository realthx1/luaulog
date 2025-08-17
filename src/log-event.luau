--!optimize 2
--!native

local LogLevel = require "./log-level"

local mod = {}

export type LogEvent = {
	Args: { unknown },
	Timestamp: number,
	Prefixes: { string },
	Postfixes: { string },
	Message: number?,
	LogLevel: LogLevel.LogLevel,
	Context: { (string | number)? }?,
}

local function new(level: LogLevel.LogLevel, args: { unknown }, context: { (string | number)? }?): LogEvent
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
