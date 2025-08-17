--!optimize 2
--!native

local configuration = require "@self/configuration"
local logsink = require "@self/sink"
local logenricher = require "@self/enricher"
local logevent = require "@self/event"
local loglevel = require "@self/level"
local logger = require "@self/logger"

local LogLevelEnricher = require "@self/common/enrichers/level-enricher"
local TimestampEnricher = require "@self/common/enrichers/timestamp-enricher"
local SourceEnricher = require "@self/common/enrichers/source-enricher"
local TraceEnricher = require "@self/common/enrichers/trace-enricher"
local RobloxLogSink = require "@self/common/sinks/roblox-log-sink"

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
mod.TraceEnricher = TraceEnricher
mod.RobloxLogSink = RobloxLogSink

return mod
