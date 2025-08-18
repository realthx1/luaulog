--!optimize 2
--!native

local enumLogLevel = {
	Verbose = 2,
	Debugging = 3,
	Information = 4,
	Warning = 5,
	Error = 6,
	Fatal = 7,
}

export type Enum = number

return enumLogLevel
