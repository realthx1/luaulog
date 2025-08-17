--!optimize 2
--!native

local logenricher = require "../log-enricher"
local logevent = require "../log-event"

return function(): logenricher.LogEnricher
	return logenricher.new(function(_: logenricher.LogEnricher, event: logevent.LogEvent): (nil, string?)
		return nil, event.Context and (event.Context :: any)[4]
	end)
end
