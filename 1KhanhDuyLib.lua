local UI = loadstring(game:HttpGet("URL_RAW"))()

-- Khởi tạo UI
local myUI = UI.new("Premium UI", {
    Main = Color3.fromRGB(255, 209, 220), -- Hồng pastel
    Accent = Color3.fromRGB(180, 255, 210) -- Mint pastel
})

-- Thêm tab
local mainTab = myUI:AddTab("Main")
local playerTab = myUI:AddTab("Player")

-- Thêm controls
mainTab:AddToggle("Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)

mainTab:AddSlider("Farm Range", 1, 100, 50, function(value)
    print("Range set to:", value)
end)

playerTab:AddDropdown("Character", {"Default", "VIP", "Legend"}, function(selected)
    print("Selected:", selected)
end)

-- Hiển thị
myUI:Render()
