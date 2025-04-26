-- Made by Yee_Kunkun

--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeadRailsMenu"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Dead Rails Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

--// Tabs
local Tabs = Instance.new("Frame", MainFrame)
Tabs.Size = UDim2.new(0, 120, 1, -40)
Tabs.Position = UDim2.new(0, 0, 0, 40)
Tabs.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Tabs.BorderSizePixel = 0

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -120, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0

local TabsList = {
    "Attack",
    "Teleport",
    "Utility"
}

local Buttons = {}
local CurrentTab = nil

--// Functions
local function ClearContent()
    for _, child in pairs(ContentFrame:GetChildren()) do
        if not child:IsA("UICorner") then
            child:Destroy()
        end
    end
end

local function SwitchTab(tabName)
    ClearContent()
    if tabName == "Attack" then
        -- Attack Content (Aimbot Toggle)
        local AimbotButton = Instance.new("TextButton", ContentFrame)
        AimbotButton.Size = UDim2.new(0, 200, 0, 50)
        AimbotButton.Position = UDim2.new(0, 20, 0, 20)
        AimbotButton.Text = "Toggle Aimbot"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        AimbotButton.Font = Enum.Font.GothamBold
        AimbotButton.TextSize = 16

        local aimbotEnabled = false

        AimbotButton.MouseButton1Click:Connect(function()
            aimbotEnabled = not aimbotEnabled
            if aimbotEnabled then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/main/aimbotScript.lua"))()
            end
        end)

    elseif tabName == "Teleport" then
        -- Teleport Content (TP to End)
        local TPButton = Instance.new("TextButton", ContentFrame)
        TPButton.Size = UDim2.new(0, 200, 0, 50)
        TPButton.Position = UDim2.new(0, 20, 0, 20)
        TPButton.Text = "Teleport to End"
        TPButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TPButton.Font = Enum.Font.GothamBold
        TPButton.TextSize = 16

        TPButton.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/main/TPtoEnd.lua"))()
        end)

    elseif tabName == "Utility" then
        -- Utility Content (Add Extra Features)
        local GodModeButton = Instance.new("TextButton", ContentFrame)
        GodModeButton.Size = UDim2.new(0, 200, 0, 50)
        GodModeButton.Position = UDim2.new(0, 20, 0, 20)
        GodModeButton.Text = "Toggle Godmode"
        GodModeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GodModeButton.Font = Enum.Font.GothamBold
        GodModeButton.TextSize = 16

        local godModeEnabled = false

        GodModeButton.MouseButton1Click:Connect(function()
            godModeEnabled = not godModeEnabled
            if godModeEnabled then
                -- Activate Godmode here (example: invincibility, no damage, etc.)
                -- Replace with the actual Godmode code
                game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
                game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
            else
                -- Deactivate Godmode
                game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
                game.Players.LocalPlayer.Character.Humanoid.Health = 100
            end
        end)

        local SpeedButton = Instance.new("TextButton", ContentFrame)
        SpeedButton.Size = UDim2.new(0, 200, 0, 50)
        SpeedButton.Position = UDim2.new(0, 20, 0, 80)
        SpeedButton.Text = "Toggle Speed"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SpeedButton.Font = Enum.Font.GothamBold
        SpeedButton.TextSize = 16

        local speedEnabled = false

        SpeedButton.MouseButton1Click:Connect(function()
            speedEnabled = not speedEnabled
            if speedEnabled then
                -- Enable Speed here (e.g., increase walk speed)
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
            else
                -- Reset Speed
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end)
    end
end

for i, tabName in ipairs(TabsList) do
    local TabButton = Instance.new("TextButton", Tabs)
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Position = UDim2.new(0, 0, 0, (i-1)*40)
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 16
    TabButton.BorderSizePixel = 0

    TabButton.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)

    table.insert(Buttons, TabButton)
end

SwitchTab("Attack") -- Default Tab

--// Moon Icon Button (Toggle Menu)
local MoonButton = Instance.new("TextButton", ScreenGui)
MoonButton.Size = UDim2.new(0, 40, 0, 40)
MoonButton.Position = UDim2.new(0.5, -20, 0, 20)
MoonButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MoonButton.Text = "🌙"
MoonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoonButton.Font = Enum.Font.GothamBold
MoonButton.TextSize = 24
MoonButton.BorderSizePixel = 0
MoonButton.BackgroundTransparency = 1

-- Toggle Menu Visibility
local menuVisible = true

MoonButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    MoonButton.Text = menuVisible and "🌙" or "🌑"
end)
