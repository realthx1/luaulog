--!optimize 2
--!native

local logevent = require "./event"

local mod = {}

export type LogFilter = (logevent.LogEvent) -> boolean

local function new(filterFn: (logevent.LogEvent) -> boolean): LogFilter
	return function(event: logevent.LogEvent): boolean
		return filterFn(event)
	end
end

mod.new = new

return mod
