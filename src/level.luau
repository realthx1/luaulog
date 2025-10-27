--!optimize 2
--!native

local enumLogLevel = {
	--- backwards compatability, use Trace instead
	Verbose = 2,
	Trace = 2,
	Debugging = 3,
	Information = 4,
	Warning = 5,
	Error = 6,
	Fatal = 7,
}

export type Enum = number

return enumLogLevel
