--!optimize 2
--!native

local logsink = require "./log-sink"
local logenricher = require "./log-enricher"
local logevent = require "./log-event"
local LogLevel = require "./log-level"
local getContext = require "./get-context"

local mod = {}

export type Logger = setmetatable<{
	minLogLevel: LogLevel.LogLevel,
	sinks: { logsink.LogSink },
	enrichers: { logenricher.LogEnricher },
}, { __index: typeof(mod) }>

local function new(enrichers: { logenricher.LogEnricher }?, sinks: { logsink.LogSink }?): Logger
	local logger: Logger = setmetatable({
		minLogLevel = LogLevel.Verbose,
		sinks = sinks or {},
		enrichers = enrichers or {},
	}, { __index = mod })

	return logger
end

local function setMinLevel(self: Logger, minLevel: LogLevel.LogLevel): Logger
	self.minLogLevel = minLevel
	return self
end
local function setSinks(self: Logger, sinks: { logsink.LogSink }): Logger
	self.sinks = sinks
	return self
end
local function setEnrichers(self: Logger, enrichers: { logenricher.LogEnricher }): Logger
	self.enrichers = enrichers
	return self
end

local function write(
	self: Logger,
	level: LogLevel.LogLevel,
	context: { (string | number)? }?,
	...: any
): logevent.LogEvent?
	if self.minLogLevel > level then return nil end
	local event: logevent.LogEvent = logevent.new(level, { ... }, context or getContext())

	for _, enricher: logenricher.LogEnricher in self.enrichers do
		enricher:Enrich(event)
	end
	for _, sink: logsink.LogSink in self.sinks do
		sink:Emit(event)
	end

	return event
end

local function Verbose(self: Logger, ...: any): logevent.LogEvent?
	return self:write(LogLevel.Verbose, getContext(), ...) :: logevent.LogEvent?
end
local function Debug(self: Logger, ...: any): logevent.LogEvent?
	return self:write(LogLevel.Debugging, getContext(), ...) :: logevent.LogEvent?
end
local function Info(self: Logger, ...: any): logevent.LogEvent?
	return self:write(LogLevel.Information, getContext(), ...) :: logevent.LogEvent?
end
local function Warn(self: Logger, ...: any): logevent.LogEvent?
	return self:write(LogLevel.Warning, getContext(), ...) :: logevent.LogEvent?
end
local function Error(self: Logger, ...: any): logevent.LogEvent?
	return self:write(LogLevel.Error, getContext(), ...) :: logevent.LogEvent?
end
local function Fatal(self: Logger, ...: any): logevent.LogEvent?
	return self:write(LogLevel.Fatal, getContext(), ...) :: logevent.LogEvent?
end

mod.setMinLevel = setMinLevel
mod.setSinks = setSinks
mod.setEnrichers = setEnrichers

mod.write = write

mod.Verbose = Verbose
mod.Debug = Debug
mod.Info = Info
mod.Warn = Warn
mod.Error = Error
mod.Fatal = Fatal

mod.new = new

return mod
