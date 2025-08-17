--!optimize 2
--!native

return function(stackOverride: number?): { (string | number)? }
	local ok: boolean, s: string?, n: number?, l: string? = pcall(debug.info, stackOverride or 3, "snl")
	if not ok then s = nil end
	return { s, n, l, debug.traceback() }
end
