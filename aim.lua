--// Script chính dùng KhanhDuyLib
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/UiRedz.lua"))() -- Bạn thay LINK bằng link upload thư viện

local Window = Library:CreateWindow("KhanhDuy Menu")

-- Tab Main
local MainTab = Window:CreateTab("Main")
Library:CreateToggle(MainTab, "Auto Bond", function(state)
    print("Auto Bond: ", state)
end)
Library:CreateToggle(MainTab, "FullBright", function(state)
    if state then
        game.Lighting.Brightness = 2
        game.Lighting.FogEnd = 100000
    else
        game.Lighting.Brightness = 1
        game.Lighting.FogEnd = 1000
    end
end)
Library:CreateToggle(MainTab, "NoClip", function(state)
    -- Basic NoClip (simple)
    local character = game.Players.LocalPlayer.Character
    if state then
        if character then
            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    else
        if character then
            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end)

-- Tab Aim
local AimTab = Window:CreateTab("Aim")
Library:CreateToggle(AimTab, "Aimbot", function(state)
    print("Aimbot: ", state)
end)
Library:CreateSlider(AimTab, "FOV", 10, 500, 50, function(value)
    print("FOV set to: ", value)
end)

-- Tab ESP
local ESPTab = Window:CreateTab("ESP")
Library:CreateToggle(ESPTab, "Enable ESP", function(state)
    print("ESP: ", state)
end)

-- Tab Teleport
local TeleportTab = Window:CreateTab("Teleport")
Library:CreateButton(TeleportTab, "Teleport to Train", function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(100,0,100))
end)
Library:CreateButton(TeleportTab, "Teleport to Tesla", function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(200,0,200))
end)
Library:CreateButton(TeleportTab, "Teleport to Fort", function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(300,0,300))
end)
Library:CreateButton(TeleportTab, "Teleport to Sterling", function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(400,0,400))
end)
Library:CreateButton(TeleportTab, "Teleport to End", function()
    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(500,0,500))
end)

-- Toggle Menu Button
Library:CreateToggleMenu()
