--!optimize 2
--!native

-- Roblox output functions are STUPIDLY slow
-- we are talking about 30x in studio and 4x the time pure logger call takes
-- the functions take 120us in studio and 20us in live servers

local EnumLogLevel = require "../level"
local logsink = require "../sink"
local logevent = require "../event"
local render = require "../utils/common-renderer"

export type RobloxLogSinkConfig = {
	--- Determines if the sink should throw errors instead of using calling warn
	ThrowErrors: boolean?,
	--[=[
		Custom function that renders and returns prefixes and postfixes as strings
		Accepts LogEvent as the first parameter
	]=]
	CustomRenderer: ((logevent.LogEvent) -> (string?, string?))?,
}

return function(config: RobloxLogSinkConfig?): logsink.LogSink
	local renderer: (logevent.LogEvent) -> (string?, string?) = render
	local throwErrors: boolean = false
	if config then
		renderer = config.CustomRenderer or renderer
		if config.ThrowErrors ~= nil then throwErrors = config.ThrowErrors end
	end
	return logsink.new(function(event: logevent.LogEvent): ()
		local logLevel: number = event.LogLevel
		local outputFn: <T...>(T...) -> () = print
		if logLevel > EnumLogLevel.Information then outputFn = warn end

		local prefix: string?, postfix: string? = renderer(event)
		if throwErrors and logLevel >= EnumLogLevel.Error then
			local fullRender: string = prefix and prefix .. " " or ""
			for _, arg: unknown in event.Args do
				fullRender ..= tostring(arg) .. " "
			end
			if postfix then
				fullRender ..= "\n" .. postfix
			end
			error(fullRender)
		else
			local fullArgs: { unknown } = table.create(#event.Args + 2)

			if prefix then
				table.insert(fullArgs, prefix)
				table.move(event.Args, 1, #event.Args, 2, fullArgs)
			else
				table.move(event.Args, 1, #event.Args, 1, fullArgs)
			end

			if postfix then table.insert(fullArgs, postfix) end
			outputFn(unpack(fullArgs))
		end
	end)
end
