--!optimize 2
--!native

--- the stack should look like this:
--- 1: this function
--- 2: caller which needs to collect data
--- 3: function to collect data from
--- @returns
return function(stackOverride: number?): { (string | number)? }
	local ok, s, n, l = pcall(debug.info, stackOverride or 3, "snl")
	if not ok then s = nil end
	return { s, n, l, debug.traceback() }
end
