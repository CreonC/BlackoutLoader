# Blackout Games Project Loader (BlackoutLoader)

## todo: type something about this project lol

### Update loader (Paste this into the command bar):
```lua



local Downloadurl = game.HttpService:JSONDecode(game:GetService("HttpService"):GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/UpdateLoader/Update.lua",true))
local Downloadurl2 = Downloadurl.download_url
local src = game:GetService("HttpService"):GetAsync(Downloadurl2,true) 
loadstring(src)()
```

