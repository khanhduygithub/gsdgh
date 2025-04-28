-- NovaX UI Library - Premium Edition
-- Phiên bản cao cấp với icon và khả năng di chuyển menu

local NovaX = {}

-- Cấu hình màu sắc cao cấp
local colorPalette = {
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(85, 0, 255),
    Dark = Color3.fromRGB(15, 15, 15),
    Darker = Color3.fromRGB(10, 10, 10),
    Light = Color3.fromRGB(240, 240, 240),
    Success = Color3.fromRGB(0, 200, 83),
    Danger = Color3.fromRGB(255, 40, 40),
    Warning = Color3.fromRGB(255, 175, 0)
}

-- Service references
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

local function createGradient(parent, rotation)
    local gradient = createInstance("UIGradient", {
        Rotation = rotation or 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colorPalette.Primary),
            ColorSequenceKeypoint.new(1, colorPalette.Secondary)
        }),
        Parent = parent
    })
    return gradient
end

local function tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.25,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main Window Creation
function NovaX:CreateWindow(config)
    config = config or {}
    
    local nova = {
        Tabs = {},
        CurrentTab = nil,
        Open = true,
        Draggable = true
    }

    -- Main UI Instances
    local screenGui = createInstance("ScreenGui", {
        Name = "NovaXUI_"..tostring(math.random(1, 10000)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local mainFrame = createInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = colorPalette.Darker,
        BorderSizePixel = 0,
        Position = UDim2.new(0.3, 0, 0.3, 0),
        Size = UDim2.new(0, 500, 0, 450),
        ClipsDescendants = true,
        ZIndex = 10
    })

    local mainCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })

    local mainStroke = createInstance("UIStroke", {
        Color = colorPalette.Primary,
        Thickness = 2,
        Parent = mainFrame
    })

    -- Header with gradient
    local header = createInstance("Frame", {
        Name = "Header",
        BackgroundColor3 = colorPalette.Dark,
        Size = UDim2.new(1, 0, 0, 50),
        ZIndex = 11
    })

    createGradient(header)

    local headerCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = header
    })

    local titleLabel = createInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.05, 0, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = config.Name or "NovaX UI",
        TextColor3 = colorPalette.Light,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12
    })

    -- Icon system
    if config.Icon then
        local icon = createInstance("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.02, 0, 0.2, 0),
            Size = UDim2.new(0, 30, 0, 30),
            Image = config.Icon,
            ZIndex = 12
        })
        icon.Parent = header
        titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
    end

    local closeButton = createInstance("ImageButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.9, 0, 0.2, 0),
        Size = UDim2.new(0, 25, 0, 25),
        Image = "rbxassetid://3926305904", -- Roblox close icon
        ImageColor3 = colorPalette.Light,
        ZIndex = 12
    })

    -- Tab system
    local tabContainer = createInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = colorPalette.Dark,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 120, 0, 400),
        ZIndex = 11
    })

    local tabListLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local contentContainer = createInstance("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 50),
        Size = UDim2.new(0, 380, 0, 400),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = colorPalette.Primary,
        ZIndex = 11
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

    -- Draggable window functionality
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        mainFrame.Position = newPos
    end

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and nova.Draggable then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)

    -- Close button functionality with animation
    closeButton.MouseButton1Click:Connect(function()
        nova.Open = not nova.Open
        if nova.Open then
            tween(mainFrame, {Size = UDim2.new(0, 500, 0, 450)})
            tween(closeButton, {Rotation = 0})
        else
            tween(mainFrame, {Size = UDim2.new(0, 500, 0, 50)})
            tween(closeButton, {Rotation = 180})
        end
    end)

    -- Tab system with icons
    function nova:CreateTab(name, iconAssetId)
        local tab = {
            Name = name,
            Elements = {}
        }

        -- Tab button with optional icon
        local tabButton = createInstance("TextButton", {
            Name = name.."Tab",
            BackgroundColor3 = colorPalette.Dark,
            Size = UDim2.new(0.9, 0, 0, 40),
            Text = "  "..name,
            Font = Enum.Font.Gotham,
            TextColor3 = colorPalette.Light,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            LayoutOrder = #self.Tabs + 1
        })

        local tabCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = tabButton
        })

        -- Add icon if provided
        if iconAssetId then
            local tabIcon = createInstance("ImageLabel", {
                Name = "TabIcon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0.05, 0, 0.2, 0),
                Size = UDim2.new(0, 25, 0, 25),
                Image = iconAssetId,
                ImageColor3 = colorPalette.Primary
            })
            tabIcon.Parent = tabButton
            tabButton.Text = "      "..name
        end

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

        -- Tab switching with animation
        tabButton.MouseButton1Click:Connect(function()
            if nova.CurrentTab then
                nova.CurrentTab.Content.Visible = false
            end
            
            -- Animate tab change
            for _, btn in ipairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    tween(btn, {BackgroundColor3 = colorPalette.Dark})
                end
            end
            
            tween(tabButton, {BackgroundColor3 = colorPalette.Primary})
            tabContent.Visible = true
            nova.CurrentTab = tab
        end)

        -- Add button element with icon support
        function tab:AddButton(config)
            local button = createInstance("TextButton", {
                Name = config.Name or "Button",
                BackgroundColor3 = colorPalette.Dark,
                Size = UDim2.new(0.95, 0, 0, 40),
                Text = config.Name or "Button",
                Font = Enum.Font.Gotham,
                TextColor3 = colorPalette.Light,
                TextSize = 14,
                AutoButtonColor = false,
                LayoutOrder = #self.Elements + 1
            })

            local buttonCorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = button
            })

            local buttonStroke = createInstance("UIStroke", {
                Color = colorPalette.Primary,
                Thickness = 1,
                Parent = button
            })

            -- Add icon if provided
            if config.Icon then
                local buttonIcon = createInstance("ImageLabel", {
                    Name = "ButtonIcon",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.05, 0, 0.2, 0),
                    Size = UDim2.new(0, 25, 0, 25),
                    Image = config.Icon,
                    ImageColor3 = colorPalette.Light
                })
                buttonIcon.Parent = button
                button.Text = "      "..(config.Name or "Button")
            end

            -- Hover effects
            button.MouseEnter:Connect(function()
                tween(button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            end)

            button.MouseLeave:Connect(function()
                tween(button, {BackgroundColor3 = colorPalette.Dark})
            end)

            button.MouseButton1Click:Connect(function()
                tween(button, {BackgroundColor3 = colorPalette.Primary})
                task.wait(0.1)
                tween(button, {BackgroundColor3 = colorPalette.Dark})
                
                if config.Callback then
                    config.Callback()
                end
            end)

            table.insert(self.Elements, button)
            button.Parent = tabContent
            return button
        end

        -- Initial setup
        if #self.Tabs == 0 then
            tabContent.Visible = true
            tween(tabButton, {BackgroundColor3 = colorPalette.Primary})
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

return NovaX
