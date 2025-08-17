--!optimize 2
--!native

local LogLevel = require "../log-level"
local logsink = require "../log-sink"
local logevent = require "../log-event"
local render = require "./common-renderer"

return function(): logsink.LogSink
	return logsink.new(function(_: logsink.LogSink, event: logevent.LogEvent)
		local outputFn = print
		if event.LogLevel > LogLevel.Information then outputFn = warn end

		local prefix: string?, postfix: string? = render(event)
		if prefix then
			outputFn(prefix, unpack(event.Args), postfix)
		else
			outputFn(unpack(event.Args), postfix)
		end
	end)
end
