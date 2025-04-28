-- UltraX UI Library
-- Kết hợp tinh hoa từ Orion và Rayfield

local UltraX = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local Config = {
    PrimaryColor = Color3.fromRGB(0, 170, 255),
    SecondaryColor = Color3.fromRGB(85, 0, 255),
    DarkColor = Color3.fromRGB(15, 15, 15),
    LightColor = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold,
    DefaultSize = UDim2.new(0, 500, 0, 450),
    MinimizedSize = UDim2.new(0, 500, 0, 50),
    TabWidth = 120,
    CornerRadius = UDim.new(0, 12),
    AnimationSpeed = 0.25
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(object, properties, duration)
    local info = TweenInfo.new(duration or Config.AnimationSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

local function AddHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = hoverColor})
    end)
    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = normalColor})
    end)
end

-- Main Window
function UltraX:CreateWindow(options)
    options = options or {}
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Minimized = false,
        Draggable = true,
        Elements = {}
    }

    -- Main GUI
    local ScreenGui = Create("ScreenGui", {
        Name = "UltraXUI_"..tostring(math.random(1, 10000)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.DarkColor,
        Position = options.Position or UDim2.new(0.3, 0, 0.3, 0),
        Size = Config.DefaultSize,
        ClipsDescendants = true
    })

    local UICorner = Create("UICorner", {
        CornerRadius = Config.CornerRadius,
        Parent = MainFrame
    })

    local UIStroke = Create("UIStroke", {
        Color = Config.PrimaryColor,
        Thickness = 2,
        Parent = MainFrame
    })

    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundColor3 = Config.PrimaryColor,
        Size = UDim2.new(1, 0, 0, 50)
    })

    local HeaderCorner = Create("UICorner", {
        CornerRadius = Config.CornerRadius,
        Parent = Header
    })

    -- Gradient Effect
    local UIGradient = Create("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Config.PrimaryColor),
            ColorSequenceKeypoint.new(1, Config.SecondaryColor)
        }),
        Parent = Header
    })

    -- Title with Icon
    local TitleContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0)
    })

    if options.Icon then
        local Icon = Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0.05, 0, 0.5, -15),
            Image = options.Icon
        })
        Icon.Parent = TitleContainer
    end

    local Title = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = options.Icon and UDim2.new(0.15, 0, 0, 0) or UDim2.new(0.05, 0, 0, 0),
        Size = options.Icon and UDim2.new(0.85, 0, 1, 0) or UDim2.new(0.95, 0, 1, 0),
        Font = Config.Font,
        Text = options.Name or "UltraX UI",
        TextColor3 = Config.LightColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Title.Parent = TitleContainer
    TitleContainer.Parent = Header

    -- Control Buttons
    local CloseButton = Create("ImageButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.9, 0, 0.5, -12),
        Size = UDim2.new(0, 25, 0, 25),
        Image = "rbxassetid://3926305904",
        ImageColor3 = Config.LightColor
    })

    -- Tab System
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, Config.TabWidth, 0, 400)
    })

    local TabListLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- Content Area
    local ContentContainer = Create("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, Config.TabWidth, 0, 50),
        Size = UDim2.new(0, Config.DefaultSize.X.Offset - Config.TabWidth, 0, 400),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Config.PrimaryColor
    })

    local ContentListLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- Auto Resize Content
    ContentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentListLayout.AbsoluteContentSize.Y + 20)
    end)

    -- Draggable Window
    local Dragging, DragInput, DragStart, StartPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and Window.Draggable then
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

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
                StartPos.X.Scale, 
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)

    -- Minimize Function
    CloseButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = Config.MinimizedSize})
            Tween(CloseButton, {Rotation = 180})
        else
            Tween(MainFrame, {Size = Config.DefaultSize})
            Tween(CloseButton, {Rotation = 0})
        end
    end)

    -- Tab Creation
    function Window:CreateTab(name, icon)
        local Tab = {
            Name = name,
            Elements = {}
        }

        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = name.."Tab",
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(0.9, 0, 0, 40),
            Text = icon and ("   "..name) or name,
            Font = Config.Font,
            TextColor3 = Config.LightColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })

        if icon then
            local TabIcon = Create("ImageLabel", {
                Name = "TabIcon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0.05, 0, 0.5, -12),
                Size = UDim2.new(0, 24, 0, 24),
                Image = icon
            })
            TabIcon.Parent = TabButton
        end

        local TabCorner = Create("UICorner", {
            CornerRadius = Config.CornerRadius,
            Parent = TabButton
        })

        -- Tab Content
        local TabContent = Create("Frame", {
            Name = name.."Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        local TabContentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        -- Tab Switching
        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
            end
            
            -- Animate tab change
            for _, btn in ipairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
                end
            end
            
            Tween(TabButton, {BackgroundColor3 = Config.PrimaryColor})
            TabContent.Visible = true
