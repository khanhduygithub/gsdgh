-- Load thư viện
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/1KhanhDuyLib.lua"))()

local Window = Library:CreateWindow("Script Menu")

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

-- Noclip thực thi
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

-- Aimbot thực thi
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

RunService.RenderStepped:Connect(function()
    if getgenv().AimbotEnabled then
        local closestPlayer = nil
        local shortestDistance = math.huge
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = v
                    end
                end
            end
        end
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.Head.Position)
        end
    end
end)

-- Tab 3: ESP
local ESPTab = Window:CreateTab("ESP")
-- (Bạn tự thêm ESP vào đây sau)

-- Tab 4: Teleport
local TeleportTab = Window:CreateTab("Teleport")

TeleportTab:CreateButton("Teleport to Spawn", function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(Vector3.new(0, 10, 0)) -- Vị trí spawn mẫu
    end
end)
