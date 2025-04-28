--// KhanhDuy Custom Menu Mini Version

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhanhDuyHubMini"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tạo Frame chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250) -- nhỏ hơn
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "KhanhDuy Hub - DeadRails"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Tabs Container
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 100, 0, 210)
TabsFrame.Position = UDim2.new(0, 10, 0, 35)
TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 6)
TabsCorner.Parent = TabsFrame

-- Nội dung các tab
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 280, 0, 210)
ContentFrame.Position = UDim2.new(0, 110, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = ContentFrame

-- Các tab
local Tabs = {"Main", "Aim", "ESP", "Teleport"}

for i, name in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -20, 0, 40)
    TabButton.Position = UDim2.new(0, 10, 0, 10 + (i-1)*50)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Text = name
    TabButton.TextScaled = true
    TabButton.Parent = TabsFrame

    local TabUICorner = Instance.new("UICorner")
    TabUICorner.CornerRadius = UDim.new(0, 6)
    TabUICorner.Parent = TabButton
end

-- Nút KhanhDuy đóng/mở menu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.Text = "KhanhDuy"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true
ToggleButton.Parent = ScreenGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

local MenuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    MainFrame.Visible = MenuVisible
end)

-- Kéo thả Menu
local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
