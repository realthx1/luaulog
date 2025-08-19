--!optimize 2
--!native

local logevent = require "./event"
local logfilter = require "./filter"

local mod = {}

export type LogEnricher = {
	Enrich: (logevent.LogEvent) -> (),
	filters: { logfilter.LogFilter },
}

local function raw(callback: (logevent.LogEvent) -> ()): LogEnricher
	local enricher: LogEnricher = {
		Enrich = callback,
		filters = {},
	}

	return enricher
end
local function new(callback: (logevent.LogEvent) -> (string?, string?)): LogEnricher
	return raw(function(event: logevent.LogEvent): ()
		local prefix: string?, postfix: string? = callback(event)
		if prefix then table.insert(event.Prefixes, prefix) end
		if postfix then table.insert(event.Postfixes, postfix) end
	end)
end

mod.raw = raw
mod.new = new

return mod
