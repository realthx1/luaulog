--!optimize 2
--!native

local logenricher = require "../log-enricher"
local logevent = require "../log-event"

return function(maxParents: number?, showLine: boolean?): logenricher.LogEnricher
	return logenricher.new(function(_: logenricher.LogEnricher, event: logevent.LogEvent): (string, nil)
		maxParents = maxParents or 1

		if not event.Context then return "?/?" .. (if showLine then ":0" else ""), nil end
		local sourceStr: string, debugName: string, lineNum: number = unpack(event.Context :: any)

		local source: string = ""

		if sourceStr and maxParents :: number > 0 then
			local sourceSplit: { string } = sourceStr:split(".")
			for i = #sourceSplit - maxParents :: number + 1, #sourceSplit do
				source ..= sourceSplit[i] .. "/"
			end
		else
			source = "?"
		end
		source ..= if debugName and debugName:len() > 0 then debugName else "?"
		if showLine then
			source ..= ":" .. tostring(lineNum) or "?"
		end

		return source, nil
	end)
end
