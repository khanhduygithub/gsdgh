-- Load Orion Library từ nguồn chính thức
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/OrionLibrary/Orion/main/source.lua'))()

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

-- Tạo 4 tab theo yêu cầu
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://7733765390"})
local AimbotTab = Window:MakeTab({Name = "Aimbot", Icon = "rbxassetid://7733921476"})
local EspTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://7733941276"})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://7734058123"})

-- ===== MAIN TAB =====
MainTab:AddLabel("Premium Hack Menu v2.0")
MainTab:AddParagraph("Status", "Ready to use")

MainTab:AddToggle({
    Name = "Kích hoạt Auto Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        OrionLib:MakeNotification({
            Name = "Thông báo",
            Content = Value and "Đã bật Auto Farm" or "Đã tắt Auto Farm",
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

MainTab:AddSlider({
    Name = "Tốc độ Farm",
    Min = 1,
    Max = 10,
    Default = 5,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    Callback = function(Value)
        _G.FarmSpeed = Value
    end    
})

-- ===== AIMBOT TAB =====
AimbotTab:AddToggle({
    Name = "Bật Aimbot",
    Default = false,
    Callback = function(Value)
        _G.AimbotEnabled = Value
    end    
})

AimbotTab:AddDropdown({
    Name = "Bộ phận nhắm",
    Default = "Head",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    Callback = function(Value)
        _G.AimbotPart = Value
    end    
})

AimbotTab:AddSlider({
    Name = "Độ nhạy",
    Min = 1,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 0),
    Callback = function(Value)
        _G.AimbotSensitivity = Value
    end    
})

-- ===== ESP TAB =====
EspTab:AddToggle({
    Name = "Bật ESP",
    Default = false,
    Callback = function(Value)
        _G.ESPEnabled = Value
    end    
})

EspTab:AddColorpicker({
    Name = "Màu ESP",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        _G.ESPColor = Value
    end    
})

EspTab:AddDropdown({
    Name = "Kiểu ESP",
    Default = "Box",
    Options = {"Box", "Tracer", "Name", "HealthBar"},
    Callback = function(Value)
        _G.ESPType = Value
    end    
})

-- ===== TELEPORT TAB =====
TeleportTab:AddButton({
    Name = "Dịch chuyển tới Spawn",
    Callback = function()
        -- Code teleport ở đây
        OrionLib:MakeNotification({
            Name = "Teleport",
            Content = "Đã dịch chuyển tới Spawn",
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

TeleportTab:AddTextbox({
    Name = "Dịch chuyển tới người chơi",
    Default = "Nhập tên",
    TextDisappear = true,
    Callback = function(Value)
        -- Code teleport to player
        OrionLib:MakeNotification({
            Name = "Teleport",
            Content = "Đang dịch chuyển tới "..Value,
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

TeleportTab:AddDropdown({
    Name = "Địa điểm nhanh",
    Default = "Chọn địa điểm",
    Options = {"Vị trí 1", "Vị trí 2", "Khu vực bí mật"},
    Callback = function(Value)
        -- Code teleport to location
        OrionLib:MakeNotification({
            Name = "Teleport",
            Content = "Đã tới "..Value,
            Image = "rbxassetid://7733697995",
            Time = 3
        })
    end    
})

-- Khởi tạo UI
OrionLib:Init()
