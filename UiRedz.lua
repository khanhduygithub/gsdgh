-- KhanhDuyLib.lua
local KhanhDuyLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhanhDuyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
MainFrame.AutomaticSize = Enum.AutomaticSize.None

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopText = Instance.new("TextLabel")
TopText.Text = "KhanhDuy"
TopText.Font = Enum.Font.GothamBold
TopText.TextSize = 20
TopText.TextColor3 = Color3.fromRGB(255, 255, 255)
TopText.BackgroundTransparency = 1
TopText.Size = UDim2.new(1, 0, 1, 0)
TopText.Parent = TopBar

local TabFolder = Instance.new("Folder", MainFrame)
TabFolder.Name = "Tabs"

function KhanhDuyLib:CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Text = name
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Size = UDim2.new(0, 130, 0, 30)
    TabButton.Position = UDim2.new(0, 10 + #TabFolder:GetChildren()*140, 0, 45)
    TabButton.Parent = MainFrame

    local UICornerBtn = Instance.new("UICorner", TabButton)
    UICornerBtn.CornerRadius = UDim.new(0, 8)

    local TabFrame = Instance.new("Frame")
    TabFrame.Name = name.."Frame"
    TabFrame.Size = UDim2.new(1, -20, 1, -90)
    TabFrame.Position = UDim2.new(0, 10, 0, 80)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.Parent = TabFolder

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(TabFolder:GetChildren()) do
            tab.Visible = false
        end
        TabFrame.Visible = true
    end)

    return TabFrame
end

function KhanhDuyLib:CreateToggle(parent, text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Text = "[ OFF ] "..text
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Size = UDim2.new(0, 200, 0, 30)
    Toggle.Parent = parent

    local UICornerToggle = Instance.new("UICorner", Toggle)
    UICornerToggle.CornerRadius = UDim.new(0, 8)

    local on = false
    Toggle.MouseButton1Click:Connect(function()
        on = not on
        Toggle.Text = (on and "[ ON  ] " or "[ OFF ] ")..text
        pcall(callback, on)
    end)
end

function KhanhDuyLib:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Size = UDim2.new(0, 200, 0, 30)
    Button.Parent = parent

    local UICornerBtn = Instance.new("UICorner", Button)
    UICornerBtn.CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

function KhanhDuyLib:CreateSlider(parent, text, min, max, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Slider = Instance.new("TextButton")
    Slider.Text = text.." ( "..tostring(min).." )"
    Slider.Font = Enum.Font.Gotham
    Slider.TextSize = 14
    Slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    Slider.Size = UDim2.new(0, 200, 0, 30)
    Slider.Position = UDim2.new(0,0,0,0)
    Slider.Parent = Frame

    local UICornerSlider = Instance.new("UICorner", Slider)
    UICornerSlider.CornerRadius = UDim.new(0, 8)

    local sliderValue = min
    Slider.MouseButton1Click:Connect(function()
        sliderValue = math.clamp(sliderValue + 10, min, max)
        Slider.Text = text.." ( "..tostring(sliderValue).." )"
        pcall(callback, sliderValue)
    end)
end

return KhanhDuyLib
