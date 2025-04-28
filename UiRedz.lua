local Library = {}
local UserInputService = game:GetService("UserInputService")

function Library:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Tabs = Instance.new("Folder")
    
    ScreenGui.Name = "KhanhDuyUI"
    ScreenGui.Parent = game.CoreGui

    Frame.Name = "MainFrame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
    Frame.Size = UDim2.new(0, 450, 0, 300)
    Frame.Active = true
    Frame.Draggable = true

    Title.Name = "Title"
    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = name or "KhanhDuy Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22

    Tabs.Name = "Tabs"
    Tabs.Parent = Frame

    -- Hide / Show
    local visible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            visible = not visible
            Frame.Visible = visible
        end
    end)

    local WindowFunctions = {}

    function WindowFunctions:CreateTab(tabname)
        local Button = Instance.new("TextButton")
        Button.Parent = Frame
        Button.Size = UDim2.new(0, 100, 0, 30)
        Button.Position = UDim2.new(0, (#Tabs:GetChildren() * 0.25), 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14
        Button.Text = tabname

        local Tab = Instance.new("Frame")
        Tab.Name = tabname
        Tab.Parent = Tabs
        Tab.Size = UDim2.new(1, 0, 1, -80)
        Tab.Position = UDim2.new(0, 0, 0, 80)
        Tab.BackgroundTransparency = 1
        Tab.Visible = false

        Button.MouseButton1Click:Connect(function()
            for _, v in pairs(Tabs:GetChildren()) do
                v.Visible = false
            end
            Tab.Visible = true
        end)

        local TabFunctions = {}

        function TabFunctions:CreateButton(btnname, callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Tab
            Btn.Size = UDim2.new(0, 200, 0, 40)
            Btn.Position = UDim2.new(0, 20, 0, #Tab:GetChildren() * 45)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Text = btnname
            Btn.MouseButton1Click:Connect(callback)
        end

        function TabFunctions:CreateToggle(toggleName, callback)
            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Tab
            Toggle.Size = UDim2.new(0, 200, 0, 40)
            Toggle.Position = UDim2.new(0, 20, 0, #Tab:GetChildren() * 45)
            Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.Text = toggleName .. ": OFF"

            local toggled = false
            Toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                Toggle.Text = toggleName .. (toggled and ": ON" or ": OFF")
                callback(toggled)
            end)
        end

        return TabFunctions
    end

    return WindowFunctions
end

return Library
