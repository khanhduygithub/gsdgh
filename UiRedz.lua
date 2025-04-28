--// KhanhDuyField Thư viện Tự Viết
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local KhanhDuyField = {}
KhanhDuyField.__index = KhanhDuyField

function KhanhDuyField:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "KhanhDuyField"

    -- Nút mở
    local OpenButton = Instance.new("TextButton", ScreenGui)
    OpenButton.Size = UDim2.new(0, 120, 0, 40)
    OpenButton.Position = UDim2.new(1, -130, 1, -50)
    OpenButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
    OpenButton.Text = title or "KhanhDuy"
    OpenButton.TextColor3 = Color3.fromRGB(255,255,255)
    OpenButton.BorderSizePixel = 0

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 10)

    local Dragging, DragInput, DragStart, StartPos

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = StartPos + UDim2.new(0, Delta.X, 0, Delta.Y)
        end
    end)

    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Tabs
    local Tabs = Instance.new("Frame", MainFrame)
    Tabs.Size = UDim2.new(0, 100, 1, 0)
    Tabs.Position = UDim2.new(0, 0, 0, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local UICorner2 = Instance.new("UICorner", Tabs)
    UICorner2.CornerRadius = UDim.new(0, 8)

    local PagesFolder = Instance.new("Folder", MainFrame)

    function self:CreateTab(name)
        local TabButton = Instance.new("TextButton", Tabs)
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255,255,255)
        TabButton.BorderSizePixel = 0

        local Page = Instance.new("Frame", PagesFolder)
        Page.Size = UDim2.new(1, -100, 1, 0)
        Page.Position = UDim2.new(0, 100, 0, 0)
        Page.Visible = false
        Page.BackgroundColor3 = Color3.fromRGB(30,30,30)

        local Layout = Instance.new("UIListLayout", Page)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 5)

        TabButton.MouseButton1Click:Connect(function()
            for _, page in pairs(PagesFolder:GetChildren()) do
                page.Visible = false
            end
            Page.Visible = true
        end)

        return Page
    end

    return self
end

function KhanhDuyField:CreateToggle(tab, text, callback)
    local ToggleButton = Instance.new("TextButton", tab)
    ToggleButton.Size = UDim2.new(1, -10, 0, 40)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
    ToggleButton.Text = "[OFF] "..text
    ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
    ToggleButton.BorderSizePixel = 0

    local State = false

    ToggleButton.MouseButton1Click:Connect(function()
        State = not State
        ToggleButton.Text = (State and "[ON] " or "[OFF] ")..text
        callback(State)
    end)

    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
    end)

    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
    end)
end

function KhanhDuyField:CreateButton(tab, text, callback)
    local Button = Instance.new("TextButton", tab)
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.BorderSizePixel = 0

    Button.MouseButton1Click:Connect(function()
        callback()
    end)

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
    end)
end

return setmetatable({}, KhanhDuyField)
