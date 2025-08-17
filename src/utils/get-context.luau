--!optimize 2
--!native

local logevent = require "../event"

return function(stackOverride: number?): logevent.LogContext
	local ok: boolean, s: string?, n: string?, l: number? = pcall(debug.info, stackOverride or 4, "snl")
	if not ok then s = nil end
	return { source = s, name = n, line = l, trace = debug.traceback() }
end
