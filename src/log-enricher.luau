--!optimize 2
--!native

local logevent = require "./log-event"
local LogLevel = require "./log-level"

local mod = {}

export type LogEnricher = setmetatable<{
	Enrich: (self: LogEnricher, logevent.LogEvent) -> (),
}, { __index: typeof(mod) }>

local function raw(callback: (self: LogEnricher, logevent.LogEvent) -> ()): LogEnricher
	local enricher: LogEnricher = setmetatable({
		minLogLevel = LogLevel.Verbose,
		maxLogLevel = LogLevel.Fatal,
		Enrich = callback,
	}, { __index = mod })

	return enricher
end
local function new(enrichFn: (self: LogEnricher, logevent.LogEvent) -> (string?, string?)): LogEnricher
	return raw(function(self: LogEnricher, event: logevent.LogEvent)
		local prefix, postfix = enrichFn(self, event)
		if prefix then table.insert(event.Prefixes, prefix) end
		if postfix then table.insert(event.Postfixes, postfix) end
	end)
end

mod.raw = raw
mod.new = new

return mod
