--!optimize 2
--!native

local enumLogLevel = {
	None = 1,
	Verbose = 2,
	Debugging = 3,
	Information = 4,
	Warning = 5,
	Error = 6,
	Fatal = 7,
	All = 8,
}

export type Enum = number

return enumLogLevel
