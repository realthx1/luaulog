--!optimize 2
--!native

local logevent = require "../event"

return function(event: logevent.LogEvent): (string?, string?)
	local prefix: string? = nil
	local postfix: string? = nil

	if #event.Prefixes > 0 then
		prefix = ""
		for idx: number, prop: string in event.Prefixes do
			if idx > 1 then
				prefix ..= " "
			end
			prefix ..= "[" .. prop .. "]"
		end
		prefix ..= ":"
	end
	if #event.Postfixes > 0 then
		postfix = ""
		for _: number, prop: string in event.Postfixes do
			postfix ..= "\n" .. prop
		end
	end
	return prefix, postfix
end
