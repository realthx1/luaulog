--!optimize 2
--!native

local EnumLogLevel = require "../level"
local logenricher = require "../enricher"
local logevent = require "../event"

local formats = {
	short = {
		[EnumLogLevel.Verbose] = "VRB",
		[EnumLogLevel.Debugging] = "DBG",
		[EnumLogLevel.Information] = "INF",
		[EnumLogLevel.Warning] = "WRN",
		[EnumLogLevel.Error] = "ERR",
		[EnumLogLevel.Fatal] = "FTL",
	},
	long = {
		[EnumLogLevel.Verbose] = "VERBOSE",
		[EnumLogLevel.Debugging] = "DEBUG",
		[EnumLogLevel.Information] = "INFO",
		[EnumLogLevel.Warning] = "WARN",
		[EnumLogLevel.Error] = "ERROR",
		[EnumLogLevel.Fatal] = "FATAL",
	},
	full = {
		[EnumLogLevel.Verbose] = "VERBOSE",
		[EnumLogLevel.Debugging] = "DEBUGGING",
		[EnumLogLevel.Information] = "INFORMATION",
		[EnumLogLevel.Warning] = "WARNING",
		[EnumLogLevel.Error] = "ERROR",
		[EnumLogLevel.Fatal] = "FATAL",
	},
}

local function LogLevelEnricher(formatType: ("short" | "long" | "full")?): logenricher.LogEnricher
	local formatPack: { string } = formats[formatType] or formats["long"]
	return logenricher.new(function(event: logevent.LogEvent): (string, nil)
		return formatPack[event.LogLevel], nil
	end)
end

local function DynSourceEnricher(showLine: boolean?, maxParents: number?): logenricher.LogEnricher
	return logenricher.new(function(event: logevent.LogEvent): (string, nil)
		maxParents = maxParents or 1

		local context: logevent.LogContext? = event.Context
		if not context then return "?/?" .. (if showLine then ":0" else ""), nil end
		local sourceStr: string?, debugName: string?, lineNum: number? = context.Source, context.Name, context.Line

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

local function TimestampEnricher(addMilliseconds: boolean?, addDate: boolean?): logenricher.LogEnricher
	return logenricher.new(function(event: logevent.LogEvent): (string, nil)
		-- datetime:format is EXPENSIVE, takes 60 microseconds usually, luau implementation takes ~1

		local timestamp: number = event.Timestamp

		local time_m: { [string]: number } = os.date("*t", timestamp) :: any
		local prefix: string = time_m.hour .. ":" .. time_m.min .. ":" .. time_m.sec
		if addMilliseconds then
			prefix ..= "." .. (timestamp % 1 * 1000) // 1
		end
		if addDate then
			prefix ..= " " .. time_m.day .. "/" .. time_m.month .. "/" .. time_m.year
		end

		return prefix, nil
	end)
end

local function TraceEnricher(): logenricher.LogEnricher
	return logenricher.new(function(event: logevent.LogEvent): (nil, string?)
		return nil, event.Context and event.Context.Trace
	end)
end

return {
	LogLevelEnricher = LogLevelEnricher,
	DynSourceEnricher = DynSourceEnricher,
	TimestampEnricher = TimestampEnricher,
	TraceEnricher = TraceEnricher,
}
