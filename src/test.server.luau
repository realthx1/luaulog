local log = require "./"

local logger = log.Logger.new({
	-- log.TimestampEnricher(true, true),
	-- log.SourceEnricher(true),
	-- log.LogLevelEnricher(),
	-- log.TraceEnricher(),
}, { log.RobloxLogSink() })

logger:Verbose("Processing cars (duh)\n", debug.traceback())
logger:write(log.LogLevel.Debugging, { "We feel freaky today" })

logger:Verbose("This should be Verbose")
logger:Debug("This should be Debug")
logger:Info("This should be Info")
logger:Warn("This should be Warn")
logger:Error("This should be Error")
logger:Fatal("This should be Fatal")

logger:Verbose("THIS SHOULDNT PRINT")
logger:Debug("THIS SHOULDNT PRINT TOO")

local start = os.clock()
logger:Info("but this should")
local endt = os.clock() - start
print(("%.3fus"):format(endt * 1000000))

-- roblox output functions are super expensive (200us)
-- timestamp enricher is expensive due to DateTime usage
-- context enricher is expensive due to debug.info and debug.traceback, but this can be improved
