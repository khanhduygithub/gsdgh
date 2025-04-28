local Nova = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/xwarehub.lua"))()

local window = Nova:CreateWindow({
    Name = "Premium Menu",
    MainColor = Color3.fromRGB(0, 150, 255),
    BackgroundColor = Color3.fromRGB(25, 25, 25),
    Theme = "Dark"
})

local mainTab = window:CreateTab("Main")
local combatTab = window:CreateTab("Combat")
local visualsTab = window:CreateTab("Visuals")
local teleportTab = window:CreateTab("Teleport")

-- Thêm các elements vào tab
mainTab:AddButton({
    Name = "Kích hoạt Auto Farm",
    Callback = function()
        print("Auto Farm activated!")
    end
})

-- Thêm nhiều elements khác tương tự
