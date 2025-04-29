-- Load DrRay UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/DrRayLib.lua"))()

-- Tạo cửa sổ chính
local Window = Library:Load("My Script GUI", "Default")

-- Tab 1: Main
local MainTab = Window.NewTab("Main")
MainTab.NewButton("Print Hello", "In ra Hello", function()
    print("Hello from Main Tab!")
end)

-- Tab 2: Combat
local CombatTab = Window.NewTab("Combat")
CombatTab.NewToggle("Auto Attack", "Tự động tấn công", function(state)
    if state then
        print("Auto Attack ON")
    else
        print("Auto Attack OFF")
    end
end)

-- Tab 3: Esp
local EspTab = Window.NewTab("Esp")
EspTab.NewButton("Enable ESP", "Bật ESP (giả lập)", function()
    print("ESP Enabled")
end)

-- Tab 4: Teleport
local TeleportTab = Window.NewTab("Teleport")
TeleportTab.NewButton("Teleport to Spawn", "Dịch chuyển đến điểm khởi đầu", function()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        player.Character:MoveTo(Vector3.new(0, 10, 0)) -- Tọa độ tùy chỉnh
    end
end)
