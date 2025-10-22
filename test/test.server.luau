--!optimize 2
--!native

local log = require(script.Parent)
local logger = log.Logger.new({
	log.Common.Enrichers.TimestampEnricher(true, true),
	log.Common.Enrichers.LogLevelEnricher(),
	log.Common.Enrichers.DynSourceEnricher(true),
	log.Common.Enrichers.TraceEnricher(),
}, { log.Common.RobloxLogSink() })

logger:Write(log.LogLevel.Debugging, { "Using an internal function cuz we can" })

logger:Verbose("This should be Verbose")
logger:Debug("This should be Debug")
logger:Info("This should be Info")
logger:Warn("This should be Warn")
logger:Error("This should be Error")
logger:Fatal("This should be Fatal")

logger:SetFilters({ log.Common.Filters.MinLevelFilter(log.LogLevel.Information) })

logger:Verbose("FAILED")
logger:Debug("FAILED")
logger:Info("PASSED")

logger:SetFilters({ log.Common.Filters.LevelListFilter({ [log.LogLevel.Warning] = true }) })

logger:Info("PASSED")
logger:Warn("FAILED")

logger:SetFilters({ log.Common.Filters.LevelListFilter({ [log.LogLevel.Warning] = true }, true) })

logger:Warn("PASSED")
logger:Info("FAILED")

logger:SetFilters({})

local bm_t: number = os.clock()
logger:Debug("Testing speed...")
local bm_dt: number = os.clock() - bm_t
print(("DT: %.3fus"):format(bm_dt * 1000000))
