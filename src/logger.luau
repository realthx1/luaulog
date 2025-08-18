--!optimize 2
--!native

local logsink = require "./sink"
local logenricher = require "./enricher"
local logfilter = require "./filter"
local logevent = require "./event"
local EnumLogLevel = require "./level"

local mod = {}

-- time tradeoff: 2 microseconds
local function getContext(stackLevel: number?): logevent.LogContext?
	stackLevel = stackLevel or 4
	local ok: boolean, s: string?, n: string?, l: number? = pcall(debug.info, stackLevel, "snl")
	if not ok then s = nil end
	return { source = s, name = n, line = l, trace = debug.traceback(nil, stackLevel) }
end

export type Logger = setmetatable<{
	sinks: { logsink.LogSink },
	enrichers: { logenricher.LogEnricher },
	filters: { logfilter.LogFilter },
}, { __index: typeof(mod) }>

local function setSinks(self: Logger, sinks: { logsink.LogSink }): Logger
	self.sinks = sinks
	return self
end
local function setEnrichers(self: Logger, enrichers: { logenricher.LogEnricher }): Logger
	self.enrichers = enrichers
	return self
end
local function setFilters(self: Logger, filters: { logfilter.LogFilter }): Logger
	self.filters = filters
	return self
end

local function Write(
	self: Logger,
	level: EnumLogLevel.Enum,
	args: { unknown },
	context: logevent.LogContext?
): logevent.LogEvent?
	local event: logevent.LogEvent = logevent.new(level, args, context or getContext())

	local loggerFilters = self.filters
	local loggerPass: boolean = true
	for _, filter: (logevent.LogEvent) -> boolean in loggerFilters do
		loggerPass = filter(event)
		if not loggerPass then break end
	end
	if not loggerPass then return event end

	for _, enricher: logenricher.LogEnricher in self.enrichers do
		local pass: boolean = true
		for _, filter: (logevent.LogEvent) -> boolean in enricher.filters do
			pass = filter(event)
			if not pass then break end
		end
		if pass then enricher.Enrich(event) end
	end
	for _, sink: logsink.LogSink in self.sinks do
		local pass: boolean = true
		for _, filter: (logevent.LogEvent) -> boolean in sink.filters do
			pass = filter(event)
			if not pass then break end
		end
		if pass then sink.Emit(event) end
	end

	return event
end

local function Verbose(self: Logger, ...: any): logevent.LogEvent?
	return self:Write(EnumLogLevel.Verbose, { ... }, getContext()) :: logevent.LogEvent?
end
local function Debug(self: Logger, ...: any): logevent.LogEvent?
	return self:Write(EnumLogLevel.Debugging, { ... }, getContext()) :: logevent.LogEvent?
end
local function Info(self: Logger, ...: any): logevent.LogEvent?
	return self:Write(EnumLogLevel.Information, { ... }, getContext()) :: logevent.LogEvent?
end
local function Warn(self: Logger, ...: any): logevent.LogEvent?
	return self:Write(EnumLogLevel.Warning, { ... }, getContext()) :: logevent.LogEvent?
end
local function Error(self: Logger, ...: any): logevent.LogEvent?
	return self:Write(EnumLogLevel.Error, { ... }, getContext()) :: logevent.LogEvent?
end
local function Fatal(self: Logger, ...: any): logevent.LogEvent?
	return self:Write(EnumLogLevel.Fatal, { ... }, getContext()) :: logevent.LogEvent?
end

local function new(
	enrichers: { logenricher.LogEnricher }?,
	sinks: { logsink.LogSink }?,
	filters: { logfilter.LogFilter }?
): Logger
	local logger: Logger = setmetatable({
		sinks = sinks or {},
		enrichers = enrichers or {},
		filters = filters or {},
	}, { __index = mod })

	return logger
end

mod.SetSinks = setSinks
mod.SetEnrichers = setEnrichers
mod.SetFilters = setFilters

mod.Write = Write

mod.Verbose = Verbose
mod.Debug = Debug
mod.Info = Info
mod.Warn = Warn
mod.Error = Error
mod.Fatal = Fatal

mod.new = new

return mod
