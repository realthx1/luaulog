--!optimize 2
--!native

local logenricher = require "../../enricher"
local logevent = require "../../event"

return function(addMilliseconds: boolean?, addDate: boolean?): logenricher.LogEnricher
	local formatString = "HH:mm:ss"
	if addMilliseconds then
		formatString ..= ".SSS"
	end
	if addDate then
		formatString ..= " DD/MM/YYYY"
	end
	return logenricher.new(function(_: logenricher.LogEnricher, event: logevent.LogEvent): (string, nil)
		-- datetime is EXPENSIVE, 20 microseconds
		local prop: string = DateTime.fromUnixTimestampMillis(event.Timestamp)
			:FormatUniversalTime(formatString, "en-us")
		return prop, nil
	end)
end
