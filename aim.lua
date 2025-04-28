-- Load thư viện (link đúng đã fix)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/main/1KhanhDuyLib.lua"))()

local Window = Library:CreateWindow("Script Menu")

-- Xóa dòng ToggleUI vì lib đã tự có nút mở menu
-- Library:ToggleUI(Enum.KeyCode.RightControl)

-- Các biến
getgenv().FullbrightEnabled = false
getgenv().NoclipEnabled = false
getgenv().AimbotEnabled = false

-- Main Tab
local MainTab = Window:CreateTab("Main")

MainTab:CreateToggle("Fullbright", false, function(state)
    getgenv().FullbrightEnabled = state
    local lighting = game:GetService("Lighting")
    if state then
        lighting.Brightness = 2
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
    else
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
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Aimbot Tab
local AimbotTab = Window:CreateTab("Aimbot")

AimbotTab:CreateToggle("Enable Aimbot", false, function(state)
    getgenv().AimbotEnabled = state
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().AimbotEnabled then
        local closest, distance = nil, math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local pos, visible = workspace.CurrentCamera:WorldToScreenPoint(player.Character.Head.Position)
                if visible then
                    local diff = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if diff < distance then
                        distance = diff
                        closest = player
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
        end
    end
end)

-- ESP Tab
local ESPTab = Window:CreateTab("ESP")
-- (Bạn thêm sau)

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport")

TeleportTab:CreateButton("Teleport to Spawn", function()
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(Vector3.new(0, 10, 0))
    end
end)
