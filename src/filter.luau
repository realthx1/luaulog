--!optimize 2
--!native

local logevent = require "./event"

local mod = {}

export type LogFilter = setmetatable<{
	Filter: (self: LogFilter, logevent.LogEvent) -> boolean,
}, { __index: typeof(mod) }>

local function raw(callback: (self: LogFilter, logevent.LogEvent) -> boolean): LogFilter
	local filter: LogFilter = setmetatable({
		Filter = callback,
	}, { __index = mod })

	return filter
end
local function new(filterFn: (self: LogFilter, logevent.LogEvent) -> boolean): LogFilter
	return raw(function(self: LogFilter, event: logevent.LogEvent): boolean
		return filterFn(self, event)
	end)
end

mod.raw = raw
mod.new = new

return mod
