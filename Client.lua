--CHANGE THIS SCRIPT IN VSC,NOT ROBLOX
print("BlackoutLoader_Client v1.1, git hash "..script.ClientGithash.Value)


local AllowDebugScripts = false


local ProjectConfiguration = game.ReplicatedFirst:WaitForChild("ProjectConfiguration")

local RunService = game:GetService("RunService")
local CurrentRelease = ProjectConfiguration:GetAttribute("Release")
local FrameWork = require(script.BlackoutFramework)

local ScriptStartupTimes = {}

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
	AllowDebugScripts = false
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


repeat task.wait()

until game.Players.LocalPlayer.Character

local BeginLoadTime = os.clock()
debug.profilebegin("ClientStartup")
for _,rscript in pairs(script.scripts:GetChildren()) do

	if rscript:IsA("ModuleScript") and not rscript:GetAttribute("Debug") then
		if AllowDebugScripts then
			DebugClient:ScriptLoading(rscript.Name)
		end
		FrameWork:WriteConfig("CurrentLoadingScript",rscript.Name)
		debuglog:debuglog("running script "..rscript.Name,debug.info(1, 'l'),script.Name)
		local ScriptStartupTime = os.clock()
		require(rscript)
		local ScriptLoadTime = tostring(string.format("%.2f", (os.clock() - ScriptStartupTime) * 1000))
		ScriptStartupTimes[rscript.Name] = ScriptLoadTime
		if AllowDebugScripts then
			DebugClient:ScriptLoaded(rscript.Name,rscript:GetFullName())
		end
		FrameWork:WriteConfig("CurrentLoadingScript",nil)
	end

end
debug.profileend()
FrameWork:WriteConfig("AreScriptsDoneLoading",true)

if CurrentRelease == "debug" then
	
	task.defer(function()
		for _,rscript in pairs(script.scripts_debug:GetChildren()) do

			if rscript:IsA("ModuleScript") and AllowDebugScripts then
				debuglog:debuglog("running debugscript "..rscript.Name,debug.info(1, 'l'),script.Name)
				require(rscript)
				rscript.Parent = LoadedScriptsLocation
			end

		end
	end)
end



local loadtime = tostring(string.format("%.2f", (os.clock() - BeginLoadTime) * 1000))
debuglog:log(string.format("Finish client startup. Took %s MS",loadtime),debug.info(1, 'l'),script.Name)

local sortedScripts = {}

for scriptName, startupTime in pairs(ScriptStartupTimes) do
	table.insert(sortedScripts, {Name = scriptName, Time = tonumber(startupTime)})
end
table.sort(sortedScripts, function(a, b)
	return a.Time > b.Time
end)

debuglog:debuglog(string.format("Listing Scripts with the biggest startup time:"),debug.info(1, 'l'),script.Name)
debuglog:debuglog(string.format("-----------------------SCRIPT_TIMINGS-----------------------"),debug.info(1, 'l'),script.Name)
for _, scriptData in ipairs(sortedScripts) do
	debuglog:debuglog(string.format("| Script '%s' took %s MS to start up", scriptData.Name, scriptData.Time),debug.info(1, 'l'),script.Name)
end
debuglog:debuglog(string.format("-----------------------SCRIPT_TIMINGS_END-----------------------"),debug.info(1, 'l'),script.Name)


game.ReplicatedStorage.Events.Client.ClientfinishInit:FireServer(FrameWork:GetLoaderGithash(),loadtime)


game.OnClose = function()
	debuglog:debuglog(string.format("Client shutting down..."),debug.info(1, 'l'),script.Name)
	
	for _,rscript in pairs(script.scripts:GetChildren()) do

		if rscript:IsA("ModuleScript") and not rscript:GetAttribute("Debug") then
			
			debuglog:debuglog("Shutting down "..rscript.Name,debug.info(1, 'l'),script.Name)
			local Require = require(rscript)
			local success ,err = pcall(function()
				Require:ClientShutDown()
			end)
			if not success then
				debuglog:log(string.format("Warning: Script %s failed to shutdown. This could be an internal error, or the script didn't implement ClientShutDown(). Anyways here's the callback:",rscript.Name),debug.info(1, 'l'),script.Name)
				
				debuglog:debuglog(string.format("Callback: %s",err),debug.info(1, 'l'),script.Name)
			end
			
		end

	end
end
