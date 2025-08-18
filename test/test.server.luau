--!optimize 2
--!native

local log = require(script.Parent)

local logger = log.Logger.new({
	-- log.Enrichers.TimestampEnricher(true, true),
	-- log.Enrichers.DynSourceEnricher(true),
	-- log.Enrichers.LogLevelEnricher(),
	-- log.Enrichers.TraceEnricher(),
}, { log.RobloxLogSink() })

logger:Info("Just an example")
logger:Write(log.LogLevel.Debugging, { "Using an internal function cuz we can" })

logger:Verbose("This should be Verbose")
logger:Debug("This should be Debug")
logger:Info("This should be Info")
logger:Warn("This should be Warn")
logger:Error("This should be Error")
logger:Fatal("This should be Fatal")

logger:SetFilters({ log.Filters.MinLevelFilter(log.LogLevel.Information) })
logger:Verbose("THIS SHOULDNT PRINT")
logger:Debug("THIS SHOULDNT PRINT TOO")

local bm_t: number = os.clock()
logger:Info("but this should print tho")
local bm_dt: number = os.clock() - bm_t
print(("%.3fus"):format(bm_dt * 1000000))
