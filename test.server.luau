--!optimize 2
--!native

local log = require(script.Parent)

local logger = log.Logger.new({
	log.TimestampEnricher(true, true),
	log.SourceEnricher(true),
	log.LogLevelEnricher(),
	log.TraceEnricher(),
}, { log.RobloxLogSink() })

logger:Info("Just an example")
logger:write(log.LogLevel.Debugging, { "Using an internal function cuz we can" })

logger:Verbose("This should be Verbose")
logger:Debug("This should be Debug")
logger:Info("This should be Info")
logger:Warn("This should be Warn")
logger:Error("This should be Error")
logger:Fatal("This should be Fatal")

-- TODO: filters should prevent these
logger:Verbose("THIS SHOULDNT PRINT")
logger:Debug("THIS SHOULDNT PRINT TOO")

local bm_t: number = os.clock()
logger:Info("but this should print tho")
local bm_dt: number = os.clock() - bm_t
print(("%.3fus"):format(bm_dt * 1000000))
