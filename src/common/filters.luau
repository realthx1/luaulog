--!optimize 2
--!native

local EnumLogLevel = require "../level"
local logfilter = require "../filter"
local logevent = require "../event"

local function MinLevelFilter(level: EnumLogLevel.Enum): logfilter.LogFilter
	return logfilter.new(function(event: logevent.LogEvent): boolean
		return event.LogLevel >= level
	end)
end
local function MaxLevelFilter(level: EnumLogLevel.Enum): logfilter.LogFilter
	return logfilter.new(function(event: logevent.LogEvent): boolean
		return event.LogLevel <= level
	end)
end

local function LevelListFilter(levels: { [EnumLogLevel.Enum]: true }, whitelist: boolean?): logfilter.LogFilter
	return logfilter.new(function(event: logevent.LogEvent): boolean
		local exists: true = levels[event.LogLevel]
		return if if whitelist then exists else not exists then true else false
	end)
end

return {
	MinLevelFilter = MinLevelFilter,
	MaxLevelFilter = MaxLevelFilter,
	LevelListFilter = LevelListFilter,
}
