repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))() 

local Window = Fluent:CreateWindow({
    Title = "Dead Rails",
    SubTitle = "Simplified UI",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})

-- Create the 4 main tabs
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local AimbotTab = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" })
local EspTab = Window:AddTab({ Title = "ESP", Icon = "eye" })
local TeleportTab = Window:AddTab({ Title = "Teleport", Icon = "map-pin" })

-- Main Tab Content
local MainSection = MainTab:AddSection("Player Settings")

MainTab:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Adjust your movement speed",
    Default = 16,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end
})

MainTab:AddSlider("JumpPower", {
    Title = "Jump Power",
    Description = "Adjust your jump height",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").JumpPower = Value
        end
    end
})

-- Aimbot Tab Content
local AimbotSection = AimbotTab:AddSection("Aimbot Settings")

AimbotTab:AddToggle("AimbotToggle", {
    Title = "Enable Aimbot",
    Description = "Locks onto nearest enemy",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local runService = game:GetService("RunService")
        local camera = workspace.CurrentCamera

        if not _G.AimbotData then
            _G.AimbotData = { Loop = nil }
        end

        local function stopAimbot()
            if _G.AimbotData.Loop then
                _G.AimbotData.Loop:Disconnect()
                _G.AimbotData.Loop = nil
            end
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
            end
        end

        local function startAimbot()
            stopAimbot()
            
            _G.AimbotData.Loop = runService.RenderStepped:Connect(function()
                if not state then return stopAimbot() end
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                local closestNPC = nil
                local closestDistance = math.huge
                
                for _, npc in ipairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc ~= player.Character then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and hrp and humanoid.Health > 0 then
                            local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestNPC = npc
                            end
                        end
                    end
                end
                
                if closestNPC then
                    camera.CameraSubject = closestNPC:FindFirstChildOfClass("Humanoid")
                else
                    camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
                end
            end)
        end

        if state then
            player.CameraMode = Enum.CameraMode.Classic
            startAimbot()
        else
            stopAimbot()
        end
    end
})

-- ESP Tab Content
local ESPSection = EspTab:AddSection("ESP Settings")

EspTab:AddToggle("PlayerESP", {
    Title = "Player ESP",
    Description = "Show player locations",
    Default = false,
    Callback = function(state)
        if state then
            local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
            ESP:Toggle(true)
            ESP.Players = true
            ESP.Boxes = true
            ESP.Names = true
            ESP.TeamColor = true
        else
            local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
            ESP:Toggle(false)
        end
    end
})

EspTab:AddToggle("ItemESP", {
    Title = "Item ESP",
    Description = "Show important items",
    Default = false,
    Callback = function(state)
        if state then
            local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
            ESP:Toggle(true)
            ESP.Players = false
            
            -- Add ESP for important items
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("BasePart") and (item.Name:find("Bond") or item.Name:find("Ammo") or item.Name:find("Weapon")) then
                    ESP:Add(item, {
                        Name = item.Name,
                        Color = Color3.fromRGB(255, 215, 0),
                        IsEnabled = true
                    })
                end
            end
        else
            local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
            ESP:Toggle(false)
        end
    end
})

-- Teleport Tab Content
local TeleportSection = TeleportTab:AddSection("Locations")

TeleportTab:AddButton({
    Title = "Teleport to Train",
    Description = "Go to the train location",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char:MoveTo(Vector3.new(100, 10, 100)) -- Replace with actual train coordinates
        end
    end
})

TeleportTab:AddButton({
    Title = "Teleport to Bank",
    Description = "Go to the nearest bank",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char:MoveTo(Vector3.new(-200, 5, 150)) -- Replace with actual bank coordinates
        end
    end
})

TeleportTab:AddButton({
    Title = "Teleport to End",
    Description = "Go to the end game area",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char:MoveTo(Vector3.new(-424.4, 28.1, -49040.7))
        end
    end
})
