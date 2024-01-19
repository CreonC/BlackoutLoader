# Blackout Games Project Loader (BlackoutLoader)

## A not very useful framework used in [games](https://www.roblox.com/games/15845364874/testv4)

### Update loader (Paste this into the command bar):
```lua
--[[
This file is a part of BlackoutLoader and licensed under MIT License. See LICENSE.md for more info.
]]
local Downloadurl = game.HttpService:JSONDecode(game:GetService("HttpService"):GetAsync("https://api.github.com/repos/CreonC/BlackoutLoader/contents/UpdateLoader/Update.lua",true))
local Downloadurl2 = Downloadurl.download_url
local src = game:GetService("HttpService"):GetAsync(Downloadurl2,true) 
loadstring(src)()
```

