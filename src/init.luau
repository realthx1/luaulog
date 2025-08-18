--!optimize 2
--!native

local configuration = require "@self/configuration"
local logsink = require "@self/sink"
local logenricher = require "@self/enricher"
local logevent = require "@self/event"
local loglevel = require "@self/level"
local logger = require "@self/logger"

local commonenrichers = require "@self/common/enrichers"
local commonfilters = require "@self/common/filters"
local RobloxLogSink = require "@self/common/roblox-log-sink"

local mod = {}

mod.Configuration = configuration
mod.LogSink = logsink
mod.LogEnricher = logenricher
mod.LogEvent = logevent
mod.LogLevel = loglevel
mod.Logger = logger

mod.Enrichers = commonenrichers
mod.Filters = commonfilters

mod.RobloxLogSink = RobloxLogSink

return mod
