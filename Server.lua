print("BlackoutLoader_Server v1.1, git hash "..script.ServergitHash)
local BeginLoadTime = os.clock()
for _,rscript in pairs(script.scripts:GetChildren()) do
	if rscript:IsA("ModuleScript") then
		print("running servermodule "..rscript.Name)
		require(rscript)
	end
end

local loadtime = tostring(string.format("%.2f", (os.clock() - BeginLoadTime) * 1000))
print(string.format("Finish server startup. Took %s MS",loadtime))