local NovaX = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/xwarehub.lua"))()

local window = NovaX:CreateWindow({
    Name = "Premium Menu",
    Icon = "rbxassetid://7734053491" -- Icon ID
})

-- Tạo các tab với icon
local mainTab = window:CreateTab("Main", "rbxassetid://7733765390")
local combatTab = window:CreateTab("Combat", "rbxassetid://7733921476")
local visualsTab = window:CreateTab("Visuals", "rbxassetid://7733941276")
local teleportTab = window:CreateTab("Teleport", "rbxassetid://7734058123")

-- Thêm button có icon
mainTab:AddButton({
    Name = "Auto Farm",
    Icon = "rbxassetid://7733697995",
    Callback = function()
        print("Auto Farm activated!")
    end
})
