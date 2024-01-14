# Blackout Games Project Loader (BlackoutLoader)

## todo: type something about this project lol

### Update loader (hard coded, don't run it lmao):
```lua



local Downloadurl = game.HttpService:JSONDecode(game:GetService("HttpService"):GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/UpdateLoader/Update.lua",true))
local ZaRealDownloadurl = Downloadurl.download_url
print("Phase 1: Downloading Update.lua")
local src = game:GetService("HttpService"):GetAsync(ZaRealDownloadurl,true) 
print("Phase 2: loadstring Update.lua")
local Source = loadstring(src)
print("Phase 3: Execute Update.lua")
Source()
```

