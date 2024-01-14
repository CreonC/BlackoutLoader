local HttpService = game:GetService("HttpService")




local UpstreamCommits = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/commits",false))

local commitToClone = UpstreamCommits[1]

local Lastestcommits = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/commits/"..tostring(commitToClone.sha),false))

print(string.format("Got lastest commit sha: %s",string.sub(tostring(Lastestcommits.sha), 1, 7)))

local ClientLoaderFile = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/Client.lua",true))

local ClientLoaderDownloadLink = ClientLoaderFile.download_url

print("Got client download url, download client now...")

local ClientLoaderFile2 = HttpService:GetAsync(ClientLoaderDownloadLink,true)


local OldClientLoader = game.ReplicatedFirst.ProjectLoader

if OldClientLoader.ClientGithash.Value == string.sub(tostring(Lastestcommits.sha), 1, 7) then
	warn("ClientLoader already at the lastest commit, no changes.")
else
	print("Writing script.source Now")
	OldClientLoader.Source = ClientLoaderFile2
	print("Done, Writting hash now")
	OldClientLoader.ClientGithash.Value = string.sub(tostring(Lastestcommits.sha), 1, 7)
	print("Done.")
end
print("Getting Server download url...")

local ServerLoaderFile = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/Server.lua",true))

local ServerLoaderDownloadLink = ServerLoaderFile.download_url

local ServerLoaderFile2 = HttpService:GetAsync(ServerLoaderDownloadLink,true)

local OldServerLoader = game.ServerScriptService.ProjectLoader_Server

if OldServerLoader.ServergitHash.Value == string.sub(tostring(Lastestcommits.sha), 1, 7) then
	warn("ServerLoader already at the lastest commit, no changes.")
else
	print("Writing script.source Now")
	OldServerLoader.Source = ServerLoaderFile2
	print("Done, Writting hash now")
	OldServerLoader.ServergitHash.Value = string.sub(tostring(Lastestcommits.sha), 1, 7)
	print("Done.")
end
