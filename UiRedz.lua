--// KhanhDuyLib.lua

local KhanhDuyLib = {}
KhanhDuyLib.__index = KhanhDuyLib

function KhanhDuyLib:CreateWindow(Name)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = true
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 12)

    local TabHolder = Instance.new("Frame", MainFrame)
    TabHolder.Size = UDim2.new(1, 0, 0, 40)
    TabHolder.BackgroundTransparency = 1

    local TabPages = Instance.new("Frame", MainFrame)
    TabPages.Size = UDim2.new(1, 0, 1, -40)
    TabPages.Position = UDim2.new(0, 0, 0, 40)
    TabPages.BackgroundTransparency = 1

    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame
    self.TabHolder = TabHolder
    self.TabPages = TabPages

    return self
end

function KhanhDuyLib:CreateTab(Name)
    local TabButton = Instance.new("TextButton", self.TabHolder)
    TabButton.Size = UDim2.new(0, 100, 0, 30)
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.Text = Name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.TextColor3 = Color3.fromRGB(255,255,255)

    local UICorner = Instance.new("UICorner", TabButton)
    UICorner.CornerRadius = UDim.new(0,8)

    local TabFrame = Instance.new("Frame", self.TabPages)
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false

    local Layout = Instance.new("UIListLayout", TabFrame)
    Layout.Padding = UDim.new(0, 5)

    TabButton.MouseButton1Click:Connect(function()
        for _,v in pairs(self.TabPages:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = false
            end
        end
        TabFrame.Visible = true
    end)

    return TabFrame
end

function KhanhDuyLib:CreateButton(Tab, Name, Callback)
    local Button = Instance.new("TextButton", Tab)
    Button.Size = UDim2.new(0, 450, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Text = Name
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.TextColor3 = Color3.fromRGB(255,255,255)

    local UICorner = Instance.new("UICorner", Button)
    UICorner.CornerRadius = UDim.new(0,8)

    Button.MouseButton1Click:Connect(function()
        pcall(Callback)
    end)
end

function KhanhDuyLib:CreateToggle(Tab, Name, Callback)
    local Toggle = Instance.new("TextButton", Tab)
    Toggle.Size = UDim2.new(0, 450, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.Text = Name .. ": OFF"
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.TextColor3 = Color3.fromRGB(255,255,255)

    local UICorner = Instance.new("UICorner", Toggle)
    UICorner.CornerRadius = UDim.new(0,8)

    local state = false
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.Text = Name .. ": " .. (state and "ON" or "OFF")
        pcall(Callback, state)
    end)
end

function KhanhDuyLib:CreateSlider(Tab, Name, Min, Max, Default, Callback)
    local Slider = Instance.new("TextButton", Tab)
    Slider.Size = UDim2.new(0, 450, 0, 40)
    Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Slider.Text = Name .. ": " .. Default
    Slider.Font = Enum.Font.Gotham
    Slider.TextSize = 14
    Slider.TextColor3 = Color3.fromRGB(255,255,255)

    local UICorner = Instance.new("UICorner", Slider)
    UICorner.CornerRadius = UDim.new(0,8)

    local value = Default
    Slider.MouseButton1Click:Connect(function()
        value = value + 10
        if value > Max then
            value = Min
        end
        Slider.Text = Name .. ": " .. value
        pcall(Callback, value)
    end)
end

function KhanhDuyLib:CreateToggleMenu()
    local ToggleButton = Instance.new("TextButton", game.CoreGui)
    ToggleButton.Size = UDim2.new(0, 100, 0, 30)
    ToggleButton.Position = UDim2.new(0.5, -50, 0, 10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.Text = "KhanhDuy"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 14
    ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)

    local UICorner = Instance.new("UICorner", ToggleButton)
    UICorner.CornerRadius = UDim.new(0,8)

    local Visible = true
    ToggleButton.MouseButton1Click:Connect(function()
        Visible = not Visible
        self.MainFrame.Visible = Visible
    end)
end

return setmetatable({}, KhanhDuyLib)
