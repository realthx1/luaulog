--!optimize 2
--!native

local EnumLogLevel = require "../../level"
local logsink = require "../../sink"
local logevent = require "../../event"
local render = require "../../utils/common-renderer"

return function(): logsink.LogSink
	return logsink.new(function(_: logsink.LogSink, event: logevent.LogEvent)
		local outputFn = print
		if event.LogLevel > EnumLogLevel.Information then outputFn = warn end

		local prefix: string?, postfix: string? = render(event)
		if prefix then
			outputFn(prefix, unpack { unpack(event.Args), postfix })
		else
			outputFn(unpack { unpack(event.Args), postfix })
		end
	end)
end
