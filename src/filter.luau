--!optimize 2
--!native

local logevent = require "./event"

local mod = {}

export type LogFilter = (logevent.LogEvent) -> boolean

return mod
