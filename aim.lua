-- Gọi thư viện
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/1KhanhDuyLib.lua"))()

-- Tạo cửa sổ
local Window = Library:CreateWindow("KhanhDuy Hub", "Best Script Ever")

-- Tab Main
local MainTab = Window:CreateTab("Main")

MainTab:CreateButton("Auto Bond", function()
    print("Auto Bond Started!")
end)

MainTab:CreateButton("Full Bright", function()
    print("Full Bright Enabled!")
end)

MainTab:CreateToggle("Noclip", false, function(state)
    print("Noclip:", state)
end)

-- Tab Aimbot
local AimbotTab = Window:CreateTab("Aimbot")

AimbotTab:CreateToggle("Enable Aimbot", false, function(state)
    print("Aimbot Enabled:", state)
end)

AimbotTab:CreateSlider("FOV Size", {
    min = 10,
    max = 500,
    default = 100
}, function(value)
    print("FOV Size:", value)
end)

-- Tab ESP
local ESPTab = Window:CreateTab("ESP")

ESPTab:CreateToggle("Enable ESP", false, function(state)
    print("ESP Enabled:", state)
end)

-- Tab Teleport
local TeleportTab = Window:CreateTab("Teleport")

TeleportTab:CreateButton("Teleport to Train", function()
    print("Teleported to Train!")
end)

TeleportTab:CreateButton("Teleport to Tesla", function()
    print("Teleported to Tesla!")
end)

TeleportTab:CreateButton("Teleport to Fort", function()
    print("Teleported to Fort!")
end)

TeleportTab:CreateButton("Teleport to Sterling", function()
    print("Teleported to Sterling!")
end)

TeleportTab:CreateButton("Teleport to End", function()
    print("Teleported to End!")
end)
