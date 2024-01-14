# Blackout Games Project Loader (BlackoutLoader)

## todo: type something about this project lol

### Update loader:
```lua
local Headers = {
	["Authorization"] = "Bearer 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"
}

local Downloadurl = game.HttpService:JSONDecode(game:GetService("HttpService"):GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/UpdateLoader/Update.lua",true,Headers))
local ZaRealDownloadurl = Downloadurl.download_url
print("Phase 1: Downloading Update.lua")
local src = game:GetService("HttpService"):GetAsync(ZaRealDownloadurl,true,Headers) 
print("Phase 2: loadstring Update.lua")
local Source = loadstring(src)
print("Phase 3: Execute Update.lua")
Source()
```

