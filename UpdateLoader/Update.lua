local HttpService = game:GetService("HttpService")

local Headers = {
	["Authorization"] = "Bearer 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"
}



local UpstreamCommits = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/commits",false,Headers))

local commitToClone = UpstreamCommits[1]

local Lastestcommits = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/commits/"..tostring(commitToClone.sha),false,Headers))

print(string.format("Got lastest commit sha: %s",string.sub(tostring(Lastestcommits.sha), 1, 7)))

local ClientLoaderFile = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/Client.lua",true,Headers))

local ClientLoaderDownloadLink = ClientLoaderFile.download_url

print("Got client download url, download client now...")

local ClientLoaderFile2 = HttpService:GetAsync(ClientLoaderDownloadLink,true,Headers)


local OldClientLoader = game.ReplicatedFirst.ProjectLoader

if ClientLoaderFile2 == OldClientLoader.Source then
	warn("ClientLoader already at the lastest commit, no changes.")
else
	print("Writing script.source Now")
	OldClientLoader.Source = ClientLoaderFile2
	print("Done, Writting hash now")
	OldClientLoader.ClientGithash.Value = string.sub(tostring(Lastestcommits.sha), 1, 7)
	print("Done.")
end
print("Getting Server download url...")

local ServerLoaderFile = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/Server.lua",true,Headers))

local ServerLoaderDownloadLink = ServerLoaderFile.download_url

local ServerLoaderFile2 = HttpService:GetAsync(ServerLoaderDownloadLink,true,Headers)

local OldServerLoader = game.ServerScriptService.ProjectLoader_Server

if ServerLoaderFile2 == OldServerLoader.Source then
	warn("ServerLoader already at the lastest commit, no changes.")
else
	print("Writing script.source Now")
	OldServerLoader.Source = ServerLoaderFile2
	print("Done, Writting hash now")
	OldServerLoader.ServergitHash.Value = string.sub(tostring(Lastestcommits.sha), 1, 7)
	print("Done.")
end
