-- DeadRailsScript.lua
local KhanhDuyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/UiRedz.lua"))() -- Thay link đúng KhanhDuyLib

local Window = KhanhDuyLib

-- Tạo Tabs
local MainTab = Window:CreateTab("Main")
local AimbotTab = Window:CreateTab("Aimbot")
local ESPTab = Window:CreateTab("ESP")
local TeleportTab = Window:CreateTab("Teleport")

-- Main Tab
Window:CreateToggle(MainTab, "Auto Bond", function(state)
    if state then
        print("Auto Bond: ON")
    else
        print("Auto Bond: OFF")
    end
end)

Window:CreateToggle(MainTab, "Fullbright", function(state)
    if state then
        game.Lighting.Brightness = 10
    else
        game.Lighting.Brightness = 1
    end
end)

Window:CreateToggle(MainTab, "Noclip", function(state)
    if state then
        print("Noclip: ON")
    else
        print("Noclip: OFF")
    end
end)

-- Aimbot Tab
Window:CreateToggle(AimbotTab, "Enable Aimbot", function(state)
    if state then
        print("Aimbot Enabled")
    else
        print("Aimbot Disabled")
    end
end)

Window:CreateSlider(AimbotTab, "FOV Size", 10, 500, function(value)
    print("FOV set to", value)
end)

-- ESP Tab
Window:CreateToggle(ESPTab, "ESP Enabled", function(state)
    if state then
        print("ESP ON")
    else
        print("ESP OFF")
    end
end)

-- Teleport Tab
Window:CreateButton(TeleportTab, "Train", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(100, 10, 100))
end)

Window:CreateButton(TeleportTab, "Tesla", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(200, 10, 200))
end)

Window:CreateButton(TeleportTab, "Fort", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(300, 10, 300))
end)

Window:CreateButton(TeleportTab, "Sterling", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(400, 10, 400))
end)

Window:CreateButton(TeleportTab, "End", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(500, 10, 500))
end)
