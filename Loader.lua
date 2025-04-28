-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo cửa sổ chính
local Window = OrionLib:MakeWindow({
    Name = "Premium Hack UI",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionConfig",
    IntroEnabled = true,
    IntroText = "Premium Hack",
    IntroIcon = "rbxassetid://7734053491",
    Icon = "rbxassetid://7734053491"
})

-- Tạo 4 tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7733765390",
    PremiumOnly = false
})

local AimbotTab = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://7733921476",
    PremiumOnly = false
})

local EspTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://7733941276",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://7734058123",
    PremiumOnly = false
})

-- ========== MAIN TAB ==========
MainTab:AddLabel("Welcome to Premium Hack")
MainTab:AddLabel("Version 2.0")

MainTab:AddButton({
    Name = "Load Script",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "System",
            Content = "Script loaded successfully!",
            Image = "rbxassetid://7733697995",
            Time = 5
        })
    end    
})

MainTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        OrionLib:MakeNotification({
            Name = "Auto Farm",
            Content = Value and "Enabled" or "Disabled",
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

MainTab:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    Callback = function(Value)
        getgenv().FarmSpeed = Value
    end    
})

-- ========== AIMBOT TAB ==========
AimbotTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(Value)
        getgenv().AimbotEnabled = Value
    end    
})

AimbotTab:AddDropdown({
    Name = "Aimbot Target",
    Default = "Head",
    Options = {"Head", "Torso", "Random"},
    Callback = function(Value)
        getgenv().AimbotPart = Value
    end    
})

AimbotTab:AddSlider({
    Name = "Aimbot FOV",
    Min = 10,
    Max = 500,
    Default = 100,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 10,
    Callback = function(Value)
        getgenv().AimbotFOV = Value
    end    
})

-- ========== ESP TAB ==========
EspTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(Value)
        getgenv().ESPEnabled = Value
    end    
})

EspTab:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        getgenv().ESPColor = Value
    end    
})

EspTab:AddDropdown({
    Name = "ESP Type",
    Default = "Box",
    Options = {"Box", "Tracer", "Name", "All"},
    Callback = function(Value)
        getgenv().ESPType = Value
    end    
})

-- ========== TELEPORT TAB ==========
TeleportTab:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        -- Your teleport code here
        OrionLib:MakeNotification({
            Name = "Teleport",
            Content = "Teleported to spawn!",
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

TeleportTab:AddTextbox({
    Name = "Teleport to Player",
    Default = "Username",
    TextDisappear = true,
    Callback = function(Value)
        -- Your teleport to player code here
        OrionLib:MakeNotification({
            Name = "Teleport",
            Content = "Attempting to teleport to "..Value,
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

TeleportTab:AddDropdown({
    Name = "Quick Teleport Locations",
    Default = "Select Location",
    Options = {"Bank", "Base", "Secret Area", "Boss Room"},
    Callback = function(Value)
        -- Your location teleport code here
        OrionLib:MakeNotification({
            Name = "Teleport",
            Content = "Teleported to "..Value,
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

-- Init UI
OrionLib:Init()
