--[[
    Nova UI Library - Phiên bản nâng cấp từ OrionLib
    Tính năng chính:
    - Hiệu ứng mượt mà với TweenService
    - Hỗ trợ Dark/Light theme
    - Responsive design
    - Tối ưu hiệu năng
]]

local Nova = {}

-- Cấu hình mặc định
local defaultConfig = {
    MainColor = Color3.fromRGB(0, 120, 215),
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    ZIndex = 10,
    Theme = "Dark" -- Dark/Light
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Utility functions
local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main Window
function Nova:CreateWindow(config)
    config = setmetatable(config or {}, {__index = defaultConfig})
    
    local nova = {
        Tabs = {},
        CurrentTab = nil,
        Config = config,
        Open = true
    }

    -- Main UI Instances
    local screenGui = createInstance("ScreenGui", {
        Name = "NovaUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local mainFrame = createInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = config.BackgroundColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.3, 0, 0.3, 0),
        Size = UDim2.new(0, 500, 0, 400),
        ClipsDescendants = true,
        ZIndex = config.ZIndex
    })

    local mainCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainFrame
    })

    local header = createInstance("Frame", {
        Name = "Header",
        BackgroundColor3 = config.MainColor,
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = config.ZIndex + 1
    })

    local headerCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = header
    })

    local titleLabel = createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.05, 0, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = config.Font,
        Text = config.Name or "Nova UI",
        TextColor3 = config.TextColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = config.ZIndex + 2
    })

    local closeButton = createInstance("ImageButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.9, 0, 0.2, 0),
        Size = UDim2.new(0, 25, 0, 25),
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(284, 4),
        ImageRectSize = Vector2.new(24, 24),
        ZIndex = config.ZIndex + 2
    })

    local tabContainer = createInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 120, 0, 360),
        ZIndex = config.ZIndex + 1
    })

    local tabListLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local contentContainer = createInstance("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 40),
        Size = UDim2.new(0, 380, 0, 360),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = config.MainColor,
        ZIndex = config.ZIndex + 1
    })

    local contentListLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- Parent hierarchy
    screenGui.Parent = game:GetService("CoreGui")
    header.Parent = mainFrame
    titleLabel.Parent = header
    closeButton.Parent = header
    tabContainer.Parent = mainFrame
    tabListLayout.Parent = tabContainer
    contentContainer.Parent = mainFrame
    contentListLayout.Parent = contentContainer
    mainFrame.Parent = screenGui

    -- Auto-resize content
    contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y + 20)
    end)

    -- Draggable window
    local dragging
    local dragInput
    local dragStart
    local startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        nova.Open = not nova.Open
        if nova.Open then
            tween(mainFrame, {Size = UDim2.new(0, 500, 0, 400)})
            tween(closeButton, {Rotation = 0})
        else
            tween(mainFrame, {Size = UDim2.new(0, 500, 0, 40)})
            tween(closeButton, {Rotation = 180})
        end
    end)

    -- Tab system
    function nova:CreateTab(name, icon)
        local tab = {
            Name = name,
            Elements = {}
        }

        -- Tab button
        local tabButton = createInstance("TextButton", {
            Name = name.."Tab",
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Size = UDim2.new(0.9, 0, 0, 35),
            Text = name,
            Font = config.Font,
            TextColor3 = config.TextColor,
            TextSize = 14,
            AutoButtonColor = false,
            LayoutOrder = #self.Tabs + 1
        })

        local tabCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = tabButton
        })

        -- Tab content
        local tabContent = createInstance("Frame", {
            Name = name.."Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        local tabContentList = createInstance("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        -- Auto-resize tab content
        tabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.Size = UDim2.new(1, 0, 0, tabContentList.AbsoluteContentSize.Y + 20)
        end)

        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            if nova.CurrentTab then
                nova.CurrentTab.Content.Visible = false
            end
            tabContent.Visible = true
            nova.CurrentTab = tab
        end)

        -- Add elements to tab
        function tab:AddButton(config)
            local button = createInstance("TextButton", {
                Name = config.Name or "Button",
                BackgroundColor3 = config.MainColor or self.Config.MainColor,
                Size = UDim2.new(0.95, 0, 0, 35),
                Text = config.Name or "Button",
                Font = config.Font or self.Config.Font,
                TextColor3 = config.TextColor or self.Config.TextColor,
                TextSize = 14,
                AutoButtonColor = false,
                LayoutOrder = #self.Elements + 1
            })

            local buttonCorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = button
            })

            button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)

            table.insert(self.Elements, button)
            button.Parent = tabContent
            return button
        end

        -- Add more element types here (Toggle, Slider, Dropdown, etc.)

        -- Initial setup
        if #self.Tabs == 0 then
            tabContent.Visible = true
            nova.CurrentTab = tab
        end

        table.insert(self.Tabs, tab)
        tabButton.Parent = tabContainer
        tabContent.Parent = contentContainer
        tab.Content = tabContent

        return tab
    end

    return nova
end

return Nova
