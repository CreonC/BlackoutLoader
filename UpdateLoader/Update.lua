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
print("Starting update...")
local HttpService = game:GetService("HttpService")
local UpstreamCommits = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/commits",false))
local commitToClone = UpstreamCommits[1]
local Lastestcommits = HttpService:JSONDecode(HttpService:GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/commits/"..tostring(commitToClone.sha),false))
local ScriptEditorService = game:GetService("ScriptEditorService")

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

	--[[if OldClientLoader.Source == ClientLoaderFile2 then
		warn("ClientLoader source is the same as the new one, no changes.")
	else
		OldClientLoader.Source = ClientLoaderFile2
	end]]

	if ScriptEditorService:GetEditorSource(OldClientLoader) == ClientLoaderFile2 then
		warn("ClientLoader source is the same as the new one, no changes.")
	else
		ScriptEditorService:UpdateSourceAsync(OldClientLoader,function()
			return ClientLoaderFile2
		end)
	end

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

	--[[if OldServerLoader.Source == ServerLoaderFile2 then
		warn("ServerLoader source is the same as the new one, no changes.")
	else
		OldServerLoader.Source = ServerLoaderFile2
	end]]

	if ScriptEditorService:GetEditorSource(OldServerLoader) == ServerLoaderFile2 then
		warn("ClientLoader source is the same as the new one, no changes.")
	else
		ScriptEditorService:UpdateSourceAsync(OldServerLoader,function()
			return ServerLoaderFile2
		end)
	end

	print("Done, Writting hash now")
	OldServerLoader.ServergitHash.Value = string.sub(tostring(Lastestcommits.sha), 1, 7)
	print("Done.")
end


