--!optimize 2
--!native

local configuration = require "@self/configuration"
local logsink = require "@self/log-sink"
local logenricher = require "@self/log-enricher"
local logevent = require "@self/log-event"
local loglevel = require "@self/log-level"
local logger = require "@self/logger"

local LogLevelEnricher = require "@self/common/level-enricher"
local TimestampEnricher = require "@self/common/timestamp-enricher"
local SourceEnricher = require "@self/common/source-enricher"
local RobloxLogSink = require "@self/common/roblox-log-sink"
local TraceEnricher = require "@self/common/trace-enricher"

local mod = {}

mod.Configuration = configuration
mod.LogSink = logsink
mod.LogEnricher = logenricher
mod.LogEvent = logevent
mod.LogLevel = loglevel
mod.Logger = logger

mod.LogLevelEnricher = LogLevelEnricher
mod.TimestampEnricher = TimestampEnricher
mod.SourceEnricher = SourceEnricher
mod.RobloxLogSink = RobloxLogSink
mod.TraceEnricher = TraceEnricher

return mod
