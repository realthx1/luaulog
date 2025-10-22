local serde = require "@lune/serde"
local process = require "@lune/process"
local net = require "@lune/net"
local stdio = require "@lune/stdio"
local fs = require "@lune/fs"

local FFLAG_KINDS = { "FFlag", "FInt", "DFFlag", "DFInt" }
local FFLAG_LIST_ENDPOINT = "https://clientsettingscdn.roblox.com/v1/settings/application?applicationName=PCStudioApp"
local GLOBAL_TYPEDEF_ENDPOINT =
	"https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.lua"

local function run(prog: string, args: { string }, env: { [string]: string }?): process.ExecResult
	return process.exec(prog, args, { stdio = "forward", env = env })
end

local srcmapRes: process.ExecResult = run("argon", { "sourcemap", "--output", "sourcemap.json" })
if not srcmapRes.ok then
	stdio.ewrite(`Argon encountered an error (code {srcmapRes.code})\n{srcmapRes.stdout}\n{srcmapRes.stderr}\n`)
	process.exit(1)
end

local defFileReq: net.FetchResponse = net.request(GLOBAL_TYPEDEF_ENDPOINT)
if not defFileReq.ok then
	stdio.ewrite(`Failed to fetch global typedef file (code {defFileReq.statusCode})}\n{defFileReq.body}\n`)
	process.exit(1)
end
fs.writeFile("globalTypes.d.lua", defFileReq.body)

local flagsReq: net.FetchResponse = net.request(FFLAG_LIST_ENDPOINT)
if not flagsReq.ok then
	stdio.ewrite(`Failed to fetch FFlags (code {flagsReq.statusCode})}\n{flagsReq.body}\n`)
	process.exit(1)
end

local rawflags: { [string]: string } = serde.decode("json", flagsReq.body).applicationSettings
local flags: { [string]: string } = {}
for rawfflag: string, value: string in rawflags do
	for _, kind: string in FFLAG_KINDS do
		local flag: string = rawfflag:match("^" .. kind .. "(Luau.+)")
		if flag then
			flags[flag] = value
			break
		end
	end
end
flags["LuauSolverV2"] = "True"

local analyzeArgs = {
	"analyze",
	"--definitions",
	"globalTypes.d.lua",
	"--base-luaurc",
	".luaurc",
	"--sourcemap",
	"sourcemap.json",
	"--settings",
	".vscode/settings.json",
	"--ignore",
	"*_packages/**",
	"--ignore",
	"src/**",
	"--platform",
	"roblox",
}
for flag: string, value: string in flags do
	table.insert(analyzeArgs, "--flag:" .. flag .. "=" .. value)
end
table.insert(analyzeArgs, "src-new/")

local analyzeRes: process.ExecResult = run("luau-lsp", analyzeArgs)
if not analyzeRes.ok then
	stdio.ewrite(`luau-lsp encountered an error (code {analyzeRes.code})\n{analyzeRes.stdout}\n{analyzeRes.stderr}\n`)
	process.exit(1)
end
stdio.write("Finished analysis!\n")
process.exit(0)
