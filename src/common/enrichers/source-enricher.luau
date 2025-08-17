--!optimize 2
--!native

local logenricher = require "../../enricher"
local logevent = require "../../event"

return function(showLine: boolean?, maxParents: number?): logenricher.LogEnricher
	return logenricher.new(function(_: logenricher.LogEnricher, event: logevent.LogEvent): (string, nil)
		maxParents = maxParents or 1

		local context: logevent.LogContext? = event.Context
		if not context then return "?/?" .. (if showLine then ":0" else ""), nil end
		local sourceStr: string?, debugName: string?, lineNum: number? = context.source, context.name, context.line

		local source: string = ""

		if maxParents :: number > 0 then
			if sourceStr then
				local sourceSplit: { string } = sourceStr:split(".")
				for i = #sourceSplit - maxParents :: number + 1, #sourceSplit do
					source ..= sourceSplit[i] .. "/"
				end
			end
			if source:len() <= 0 then source = "?" end
		end
		source ..= if debugName and debugName:len() > 0 then debugName else "?"
		if showLine then
			source ..= ":" .. tostring(lineNum) or "?"
		end

		return source, nil
	end)
end
