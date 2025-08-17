--!optimize 2
--!native

local LogLevel = require "../../level"
local logenricher = require "../../enricher"
local logevent = require "../../event"

local formats = {
	short = {
		[LogLevel.Verbose] = "VRB",
		[LogLevel.Debugging] = "DBG",
		[LogLevel.Information] = "INF",
		[LogLevel.Warning] = "WRN",
		[LogLevel.Error] = "ERR",
		[LogLevel.Fatal] = "FTL",
	},
	long = {
		[LogLevel.Verbose] = "VERBOSE",
		[LogLevel.Debugging] = "DEBUG",
		[LogLevel.Information] = "INFO",
		[LogLevel.Warning] = "WARN",
		[LogLevel.Error] = "ERROR",
		[LogLevel.Fatal] = "FATAL",
	},
	full = {
		[LogLevel.Verbose] = "VERBOSE",
		[LogLevel.Debugging] = "DEBUGGING",
		[LogLevel.Information] = "INFORMATION",
		[LogLevel.Warning] = "WARNING",
		[LogLevel.Error] = "ERROR",
		[LogLevel.Fatal] = "FATAL",
	},
}

return function(formatType: ("short" | "long" | "full")?): logenricher.LogEnricher
	local formatPack: { string } = formats[formatType] or formats["long"]
	return logenricher.new(function(_: logenricher.LogEnricher, event: logevent.LogEvent): (string, nil)
		return formatPack[event.LogLevel], nil
	end)
end
