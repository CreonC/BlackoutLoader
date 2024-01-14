# Blackout Games Project Loader (BlackoutLoader)

## todo: type something about this project lol

### Update loader (Paste this into the command bar):
```lua



local Downloadurl = game.HttpService:JSONDecode(game:GetService("HttpService"):GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/UpdateLoader/Update.lua",true))
assert(Downloadurl,"Downloadurl is nil!")
local Downloadurl2 = Downloadurl.download_url
assert(Downloadurl2,"Downloadurl2 is nil!")
print("Phase 1: Downloading Update.lua")
local src = game:GetService("HttpService"):GetAsync(Downloadurl2,true) 
print("Phase 2: loadstring Update.lua")
assert(src,"src is nil!")
local Source = loadstring(src)
print("Phase 3: Execute Update.lua")
Source()
```

