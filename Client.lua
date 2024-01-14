--CHANGE THIS SCRIPT IN VSC,NOT ROBLOX
print("BlackoutLoader_Client v1.1, git hash "..script.ClientGithash.Value)


local AllowDebugScripts = false


local ProjectConfiguration = game.ReplicatedFirst:WaitForChild("ProjectConfiguration")

local RunService = game:GetService("RunService")
local CurrentRelease = ProjectConfiguration:GetAttribute("Release")
local FrameWork = require(script.BlackoutFramework)

FrameWork:WriteConfig("DoneInit",false)



if not ProjectConfiguration then
	warn(debug.traceback("Traceback:"))
	error("[BlackoutLoader]: ProjectConfiguration is nil. Not loading game.") 
end

if CurrentRelease == "debug" then
	print("[BlackoutLoader]: debug")
	AllowDebugScripts = true
elseif CurrentRelease == "prod" then
	print("[BlackoutLoader]: prod")
else
	error("[BlackoutLoader]: CurrentRelease string is invaild. Not loading game")
end

if CurrentRelease == "debug" and not RunService:IsStudio() then --who wants a debug envirement in a prod game????
	warn("[BlackoutLoader]: Correcting CurrentRelease value.") 
	CurrentRelease = "prod"
end

FrameWork:WriteConfig("CurrentRelease",CurrentRelease)

FrameWork:WriteConfig("DoneInit",true)

local debuglog = require(script.modules.debuglog)

task.defer(function()
	local DebugVersionInfo = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("DebugVersionInfo")
	
	local IsInternal = RunService:IsStudio()
	
	local isInternalText 
	
	if IsInternal then
		isInternalText = "INTERNAL BUILD"
	else
		isInternalText = ""
	end
	
	DebugVersionInfo.Text = string.format("build%s-%s-client-%s %s",game.PlaceVersion,CurrentRelease,FrameWork:GetLoaderGithash(),isInternalText)

end)



local LoadedScriptsLocation = Instance.new("Folder",script)
LoadedScriptsLocation.Name = "Runtime"

local DebugClient

if AllowDebugScripts then
	debuglog:debuglog("Allowing debug scripts to run",debug.info(1, 'l'),script.Name)
	DebugClient = require(script.modules_debug["debug/client"])
end

FrameWork:WriteConfig("DoneInit",true)
FrameWork:WriteConfig("AreScriptsDoneLoading",false)


task.spawn(function()
	if DebugClient then
		DebugClient:ScriptLoading("ui/Introscreenui")
	end
	require(script.modules["ui/Introscreenui"]) --loading this first
	if DebugClient then
		DebugClient:ScriptLoaded("ui/Introscreenui")
	end
end)

local BeginLoadTime = os.clock()
for _,rscript in pairs(script.scripts:GetChildren()) do
	
	if rscript:IsA("ModuleScript") and not rscript:GetAttribute("Debug") then
		if AllowDebugScripts then
			DebugClient:ScriptLoading(rscript.Name)
		end
		FrameWork:WriteConfig("CurrentLoadingScript",rscript.Name)
		debuglog:debuglog("running script "..rscript.Name,debug.info(1, 'l'),script.Name)
		require(rscript)
		--rscript.Parent = LoadedScriptsLocation
		if AllowDebugScripts then
			DebugClient:ScriptLoaded(rscript.Name,rscript:GetFullName())
		end
		FrameWork:WriteConfig("CurrentLoadingScript",nil)
	end
	
end
FrameWork:WriteConfig("AreScriptsDoneLoading",true)

task.defer(function()
	for _,rscript in pairs(script.scripts_debug:GetChildren()) do

		if rscript:IsA("ModuleScript") and AllowDebugScripts then

			debuglog:debuglog("running debugscript "..rscript.Name,debug.info(1, 'l'),script.Name)
			require(rscript)
			rscript.Parent = LoadedScriptsLocation
		end

	end
end)


local loadtime = tostring(string.format("%.2f", (os.clock() - BeginLoadTime) * 1000))
debuglog:log(string.format("Finish client startup. Took %s MS",loadtime),debug.info(1, 'l'),script.Name)


