--!optimize 2
--!native

local logsink = require "./sink"
local logenricher = require "./enricher"
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
}, { __index: typeof(mod) }>

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
	level: EnumLogLevel.Enum,
	args: { unknown },
	context: logevent.LogContext?
): logevent.LogEvent?
	local event: logevent.LogEvent = logevent.new(level, args, context or getContext())

	for _, enricher: logenricher.LogEnricher in self.enrichers do
		enricher:Enrich(event)
	end
	for _, sink: logsink.LogSink in self.sinks do
		sink:Emit(event)
	end

	return event
end

local function Verbose(self: Logger, ...: any): logevent.LogEvent?
	return self:write(EnumLogLevel.Verbose, { ... }, getContext()) :: logevent.LogEvent?
end
local function Debug(self: Logger, ...: any): logevent.LogEvent?
	return self:write(EnumLogLevel.Debugging, { ... }, getContext()) :: logevent.LogEvent?
end
local function Info(self: Logger, ...: any): logevent.LogEvent?
	return self:write(EnumLogLevel.Information, { ... }, getContext()) :: logevent.LogEvent?
end
local function Warn(self: Logger, ...: any): logevent.LogEvent?
	return self:write(EnumLogLevel.Warning, { ... }, getContext()) :: logevent.LogEvent?
end
local function Error(self: Logger, ...: any): logevent.LogEvent?
	return self:write(EnumLogLevel.Error, { ... }, getContext()) :: logevent.LogEvent?
end
local function Fatal(self: Logger, ...: any): logevent.LogEvent?
	return self:write(EnumLogLevel.Fatal, { ... }, getContext()) :: logevent.LogEvent?
end

local function new(enrichers: { logenricher.LogEnricher }?, sinks: { logsink.LogSink }?): Logger
	local logger: Logger = setmetatable({
		sinks = sinks or {},
		enrichers = enrichers or {},
	}, { __index = mod })

	return logger
end

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
