--CHANGE THIS SCRIPT IN VSC,NOT ROBLOX
print("BlackoutLoader_Server v1.1, git hash "..script.ServergitHash.Value)
local BeginLoadTime = os.clock()
for _,rscript in pairs(script.scripts:GetChildren()) do
	if rscript:IsA("ModuleScript") then
		print("running servermodule "..rscript.Name)
		require(rscript)
	end
end

local loadtime = tostring(string.format("%.2f", (os.clock() - BeginLoadTime) * 1000))
print(string.format("Finish server startup. Took %s MS",loadtime))

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