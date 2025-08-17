--!optimize 2
--!native

local logenricher = require "../../enricher"
local logevent = require "../../event"

return function(): logenricher.LogEnricher
	return logenricher.new(function(_: logenricher.LogEnricher, event: logevent.LogEvent): (nil, string?)
		return nil, event.Context and event.Context.trace
	end)
end
