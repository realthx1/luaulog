local luaulog = require "./"

local logger = luaulog.Logger.new({
	luaulog.TimestampEnricher(),
	luaulog.SourceEnricher(2, true),
	luaulog.LogLevelEnricher(),
	luaulog.TraceEnricher(),
}, { luaulog.RobloxLogSink() })

logger:Verbose("Processing cars (duh)\n", debug.traceback())
logger:write(luaulog.LogLevel.Debugging, nil, "We feel freaky today\n")

logger:Verbose("This should be Verbose")
logger:Debug("This should be Debug")
logger:Info("This should be Info")
logger:Warn("This should be Warn")
logger:Error("This should be Error")
logger:Fatal("This should be Fatal")

logger:setMinLevel(luaulog.LogLevel.Information)

logger:Verbose("THIS SHOULDNT PRINT")
logger:Debug("THIS SHOULDNT PRINT TOO")

local start = os.clock()
logger:Info("but this should")
local endt = os.clock() - start
logger:Fatal(("%.3f"):format(endt * 1000))
