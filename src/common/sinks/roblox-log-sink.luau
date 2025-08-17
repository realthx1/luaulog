--!optimize 2
--!native

-- Roblox output functions (at least in studio) take a STUPIDLY long amount of time to run
-- we are talking about 50x the time pure logger takes to run
-- usually, one call of those functions takes 180-260us in studio

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
