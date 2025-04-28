-- Load thư viện
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/1KhanhDuyLib.lua"))()

local Window = Library:CreateWindow("Script Menu")

-- Thêm dòng này để mở menu
Library:ToggleUI(Enum.KeyCode.RightControl)

-- Biến trạng thái
getgenv().FullbrightEnabled = false
getgenv().NoclipEnabled = false
getgenv().AimbotEnabled = false

-- Tab 1: Main
local MainTab = Window:CreateTab("Main")

MainTab:CreateToggle("Fullbright", false, function(state)
    getgenv().FullbrightEnabled = state
    if state then
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 2
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
    else
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 1
        lighting.ClockTime = 14
        lighting.FogEnd = 1000
        lighting.GlobalShadows = true
    end
end)

MainTab:CreateToggle("Noclip", false, function(state)
    getgenv().NoclipEnabled = state
end)

game:GetService("RunService").Stepped:Connect(function()
    if getgenv().NoclipEnabled then
        local player = game.Players.LocalPlayer
        if player.Character then
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- Tab 2: Aimbot
local AimbotTab = Window:CreateTab("Aimbot")

AimbotTab:CreateToggle("Enable Aimbot", false, function(state)
    getgenv().AimbotEnabled = state
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

RunService.RenderStepped:Connect(function()
    if getgenv().AimbotEnabled then
        local closestPlayer = nil
        local shortestDistance = math
