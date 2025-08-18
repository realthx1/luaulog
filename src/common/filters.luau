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

local function LevelListFilter(levels: { EnumLogLevel.Enum }, blacklist: boolean?): logfilter.LogFilter
	return logfilter.new(function(event: logevent.LogEvent): boolean
		local exists: number = levels[event.LogLevel]
		return if if blacklist then not exists else exists then true else false
	end)
end

return {
	MinLevelFilter = MinLevelFilter,
	MaxLevelFilter = MaxLevelFilter,
	LevelListFilter = LevelListFilter,
}
