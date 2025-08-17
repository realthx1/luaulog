--!optimize 2
--!native

local logenricher = require "../../enricher"
local logevent = require "../../event"

return function(addMilliseconds: boolean?, addDate: boolean?): logenricher.LogEnricher
	return logenricher.new(function(_: logenricher.LogEnricher, event: logevent.LogEvent): (string, nil)
		-- datetime:format is EXPENSIVE, takes 60 microseconds usually, luau implementation takes ~1

		local timestamp: number = event.Timestamp

		local time_m: { [string]: number } = os.date("*t", timestamp) :: any
		local prefix: string = time_m.hour .. ":" .. time_m.min .. ":" .. time_m.sec
		if addMilliseconds then
			prefix ..= "." .. (timestamp % 1 * 1000) // 1
		end
		if addDate then
			prefix ..= " " .. time_m.day .. "/" .. time_m.month .. "/" .. time_m.year
		end

		return prefix, nil
	end)
end
