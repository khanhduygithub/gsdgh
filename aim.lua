local Library = loadstring(game:HttpGet("local KhanhDuyHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/UiRedz.lua"))()

local Window = KhanhDuyHub:CreateWindow({
    Name = "KhanhDuy Hub | DeadRails",
})

local MainTab = Window:CreateTab("Main", 0)

MainTab:CreateButton({
    Name = "AutoBond",
    Callback = function()
        print("AutoBond ON")
    end,
})"))() -- (hoặc paste thẳng lib vào nếu tự lưu)

local Window = Library:CreateWindow("KhanhDuy Hub")

-- Main Tab
local MainTab = Window:CreateTab("Main")
MainTab:CreateToggle("AutoBond", function(state)
    print("AutoBond:", state)
end)

MainTab:CreateToggle("FullBright", function(state)
    if state then
        game.Lighting.Brightness = 10
        game.Lighting.Ambient = Color3.new(1, 1, 1)
    else
        game.Lighting.Brightness = 2
        game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    end
end)

MainTab:CreateToggle("NoClip", function(state)
    local noclip = state
    game:GetService('RunService').Stepped:Connect(function()
        if noclip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA('BasePart') then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

-- Aimbot Tab
local AimTab = Window:CreateTab("Aimbot")
AimTab:CreateToggle("Aimbot", function(state)
    print("Aimbot:", state)
end)

AimTab:CreateButton("Set FOV 10-500", function()
    local fov = tonumber(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.TextBox.Text)
    if fov and fov >= 10 and fov <= 500 then
        print("FOV Set To:", fov)
    else
        warn("Nhập FOV hợp lệ từ 10 đến 500")
    end
end)

-- ESP Tab
local ESPTab = Window:CreateTab("ESP")
ESPTab:CreateToggle("Enable ESP", function(state)
    print("ESP Enabled:", state)
end)

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport")
TeleportTab:CreateButton("Train", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,10,0)) -- đổi tọa độ theo map của bạn
end)

TeleportTab:CreateButton("Tesla", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(100,10,0))
end)

TeleportTab:CreateButton("Fort", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(200,10,0))
end)

TeleportTab:CreateButton("Sterling", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(300,10,0))
end)

TeleportTab:CreateButton("End", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(400,10,0))
end)
