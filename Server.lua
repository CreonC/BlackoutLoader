--[[
This file is a part of BlackoutLoader and licensed under MIT License.

MIT License

Copyright (c) 2024 CreonC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]
print("BlackoutLoader_Server v1.2, git hash "..script.ServergitHash.Value)

local ScriptStartupTimes = {}

local BeginLoadTime = os.clock()
for _,rscript in pairs(script.scripts:GetChildren()) do
	if rscript:IsA("ModuleScript") then
		print("running servermodule "..rscript.Name)
		local ScriptStartupTime = os.clock()
		require(rscript)
		local ScriptLoadTime = tostring(string.format("%.2f", (os.clock() - ScriptStartupTime) * 1000))
		ScriptStartupTimes[rscript.Name] = ScriptLoadTime
	end
end

local loadtime = tostring(string.format("%.2f", (os.clock() - BeginLoadTime) * 1000))
print(string.format("Finish server startup. Took %s MS",loadtime))


local sortedScripts = {}

for scriptName, startupTime in pairs(ScriptStartupTimes) do
	table.insert(sortedScripts, {Name = scriptName, Time = tonumber(startupTime)})
end
table.sort(sortedScripts, function(a, b)
	return a.Time > b.Time
end)

print(string.format("Listing Server Scripts with the biggest startup time:"))
print(string.format("-----------------------SCRIPT_TIMINGS_SERVER-----------------------"))
for _, scriptData in ipairs(sortedScripts) do
	print(string.format("| Script '%s' took %s MS to start up", scriptData.Name, scriptData.Time))
end
print(string.format("-----------------------SCRIPT_TIMINGS_END-----------------------"))


game.ReplicatedStorage.Events.Client.ClientfinishInit.OnServerEvent:Connect(function(Player,ClientGitHash,LoadTime:number) --loadtime in ms
	if ClientGitHash ~= script.ServergitHash.Value then
		warn(string.format("Player %s's client hash is different! (%s vs %s)",Player.Name,ClientGitHash,script.ServergitHash.Value))
	end
	local LoadTime = tonumber(LoadTime) -- fix attempt to compare string < number 
	if LoadTime < 600 then 
		print("Player have good pc")
	elseif LoadTime < 1500 then
		print("Player have mid pc")
	else
		print("Player have bad pc") --by the ai lmao
	end
end)