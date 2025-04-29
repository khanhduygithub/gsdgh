local RedLib = {}

local TweenService = game:GetService("TweenService")

function RedLib:CreateMenu()
    local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "RedLibUI"
    
    local toggleButton = Instance.new("TextButton", screenGui)
    toggleButton.Text = "≡"
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 250, 0, 300)
    frame.Position = UDim2.new(0, -260, 0.5, -150) -- ẩn ngoài màn hình lúc đầu
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.ClipsDescendants = true

    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    local isOpen = false

    toggleButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local goalPos = isOpen and UDim2.new(0, 10, 0.5, -150) or UDim2.new(0, -260, 0.5, -150)
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = goalPos}):Play()
    end)

    function RedLib:AddButton(name, callback)
        local button = Instance.new("TextButton", scroll)
        button.Size = UDim2.new(1, -12, 0, 30)
        button.Text = name
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.MouseButton1Click:Connect(callback)
    end

    return RedLib
end

return RedLib
