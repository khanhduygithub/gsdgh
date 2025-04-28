local KhanhDuyField = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/UiRedz.lua"))()

local Window = KhanhDuyField:CreateWindow("KhanhDuy")

-- Tab Main
local MainTab = Window:CreateTab("Main")
KhanhDuyField:CreateToggle(MainTab, "Auto Bond", function(state)
    if state then
        print("Auto Bond Bật")
    else
        print("Auto Bond Tắt")
    end
end)

KhanhDuyField:CreateToggle(MainTab, "FullBright", function(state)
    if state then
        game.Lighting.Brightness = 5
    else
        game.Lighting.Brightness = 1
    end
end)

KhanhDuyField:CreateToggle(MainTab, "Noclip", function(state)
    if state then
        print("Noclip Bật")
    else
        print("Noclip Tắt")
    end
end)

-- Tab Aim
local AimTab = Window:CreateTab("Aim")
KhanhDuyField:CreateToggle(AimTab, "Aimbot", function(state)
    if state then
        print("Aimbot Bật")
    else
        print("Aimbot Tắt")
    end
end)

KhanhDuyField:CreateButton(AimTab, "FOV 10-500", function()
    print("Đã chọn FOV từ 10 đến 500")
end)

-- Tab ESP
local ESPTab = Window:CreateTab("ESP")
KhanhDuyField:CreateToggle(ESPTab, "Box ESP", function(state)
    if state then
        print("ESP Bật")
    else
        print("ESP Tắt")
    end
end)

-- Tab Teleport
local TPtab = Window:CreateTab("Teleport")
KhanhDuyField:CreateButton(TPtab, "Train", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(100,0,100))
end)

KhanhDuyField:CreateButton(TPtab, "Tesla", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(200,0,200))
end)

KhanhDuyField:CreateButton(TPtab, "Fort", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(300,0,300))
end)

KhanhDuyField:CreateButton(TPtab, "Sterling", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(400,0,400))
end)

KhanhDuyField:CreateButton(TPtab, "End", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(500,0,500))
end)
