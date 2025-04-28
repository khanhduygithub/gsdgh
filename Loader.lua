-- Load UltraX Library (paste the UltraX library code here first)
local UltraX = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/xwarehub.lua"))()

-- Create Window
local Window = UltraX:CreateWindow({
    Name = "VIP HUB",
    Icon = "rbxassetid://7734053491",
    Position = UDim2.new(0.3, 0, 0.3, 0)
})

-- Create Tabs
local MainTab = Window:CreateTab("Main", "rbxassetid://7733765390")
local AimbotTab = Window:CreateTab("Aimbot", "rbxassetid://7733921476") 
local EspTab = Window:CreateTab("ESP", "rbxassetid://7733941276")
local TeleportTab = Window:CreateTab("Teleport", "rbxassetid://7734058123")

-- ========== MAIN TAB ==========
MainTab:AddButton({
    Name = "Load Script",
    Icon = "rbxassetid://7733697995",
    Callback = function()
        print("Script loaded!")
    end
})

MainTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        print("Auto Farm:", Value)
    end
})

MainTab:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(Value)
        _G.FarmSpeed = Value
        print("Farm Speed set to:", Value)
    end
})

-- ========== AIMBOT TAB ==========
AimbotTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(Value)
        _G.AimbotEnabled = Value
        print("Aimbot:", Value)
    end
})

AimbotTab:AddDropdown({
    Name = "Aimbot Target",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(Value)
        _G.AimbotPart = Value
        print("Targeting:", Value)
    end
})

-- ========== ESP TAB ==========
EspTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(Value)
        _G.ESPEnabled = Value
        print("ESP:", Value)
    end
})

EspTab:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        _G.ESPColor = Value
        print("ESP Color set to:", Value)
    end
})

-- ========== TELEPORT TAB ==========
TeleportTab:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        print("Teleported to spawn!")
    end
})

TeleportTab:AddTextbox({
    Name = "Teleport to Player",
    Placeholder = "Enter username",
    Callback = function(Text)
        print("Attempting to teleport to:", Text)
    end
})

-- Keybind for toggle UI
local Keybind = {
    Enabled = true,
    Key = Enum.KeyCode.RightControl
}

game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Keybind.Key then
        Window.Minimized = not Window.Minimized
    end
end)

print("UltraX VIP UI Loaded!")
