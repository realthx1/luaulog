--!optimize 2
--!native

local enumLogLevel = {
	Verbose = 1,
	Debugging = 2,
	Information = 3,
	Warning = 4,
	Error = 5,
	Fatal = 6,
}
type LevelProperty = {
	short: string,
	long: string,
	full: string,
}

export type LogLevel = number

return enumLogLevel
