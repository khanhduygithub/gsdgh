local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local DestroyButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local ScriptButton1 = Instance.new("TextButton")
local ScriptButton2 = Instance.new("TextButton")

-- Parent to CoreGui
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "KiciaHub"

-- Frame setup
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 250)
Frame.Position = UDim2.new(0.5, -150, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

UICorner.Parent = Frame
UIStroke.Parent = Frame
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2

-- Title
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "KiciaHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24

-- Destroy Button
DestroyButton.Parent = Frame
DestroyButton.Size = UDim2.new(0, 100, 0, 30)
DestroyButton.Position = UDim2.new(0.5, -50, 1, -40)
DestroyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
DestroyButton.Text = "Destroy GUI"
DestroyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyButton.Font = Enum.Font.SourceSans
DestroyButton.TextSize = 18
DestroyButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Script Button 1
ScriptButton1.Parent = Frame
ScriptButton1.Size = UDim2.new(0, 200, 0, 40)
ScriptButton1.Position = UDim2.new(0.5, -100, 0, 70)
ScriptButton1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScriptButton1.Text = "Game Script 1"
ScriptButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptButton1.Font = Enum.Font.SourceSans
ScriptButton1.TextSize = 20
ScriptButton1.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://your-link-here.com/script1.lua"))()
    game.StarterGui:SetCore("SendNotification", {
        Title = "KiciaHub",
        Text = "Script 1 Loaded!",
        Duration = 3
    })
end)

-- Script Button 2
ScriptButton2.Parent = Frame
ScriptButton2.Size = UDim2.new(0, 200, 0, 40)
ScriptButton2.Position = UDim2.new(0.5, -100, 0, 120)
ScriptButton2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScriptButton2.Text = "Game Script 2"
ScriptButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptButton2.Font = Enum.Font.SourceSans
ScriptButton2.TextSize = 20
ScriptButton2.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://your-link-here.com/script2.lua"))()
    game.StarterGui:SetCore("SendNotification", {
        Title = "KiciaHub",
        Text = "Script 2 Loaded!",
        Duration = 3
    })
end)
