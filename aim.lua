-- ========== FIXED SCROLLABLE MENU VERSION ==========
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- 1. Sửa lại hàm tạo Window với scrolling mượt mà
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/1KhanhDuyLib.lua", true))()

local Window = Fluent:CreateWindow({
    Title = "Dead Rails",
    SubTitle = "Scrollable Cheat Menu",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350), -- Giảm chiều cao để kích hoạt scroll
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})

-- 2. Hàm thêm scroll cho Frame
local function AddScrollToFrame(frame)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    frame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    frame.ScrollBarThickness = 6
    
    -- Tạo hiệu ứng mượt mà khi cuộn
    local scrollDebounce = false
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if scrollDebounce then return end
            scrollDebounce = true
            
            local direction = -input.Position.Z * 20 -- Tốc độ cuộn
            local targetPos = frame.CanvasPosition.Y + direction
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
            
            TweenService:Create(frame, tweenInfo, {CanvasPosition = Vector2.new(0, targetPos)}):Play()
            
            task.wait(0.1)
            scrollDebounce = false
        end
    end)
end

-- 3. Áp dụng scroll cho tất cả các tab
for _, tab in pairs(Window.Tabs) do
    tab.Container.Size = UDim2.new(1, 0, 1, -40) -- Điều chỉnh lại kích thước
    tab.Container.Position = UDim2.new(0, 0, 0, 40)
    tab.Container.CanvasSize = UDim2.new(0, 0, 2, 0) -- Tăng chiều cao nội dung
    
    AddScrollToFrame(tab.Container)
end

-- 4. Fix lỗi Kill Aura với kiểm tra an toàn
local function SafeExecuteKillAura()
    pcall(function()
        local npc = GetNearestNPC()
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            local dragRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Shared", true) 
                            and game:GetService("ReplicatedStorage").Shared:FindFirstChild("Remotes", true)
                            and game:GetService("ReplicatedStorage").Shared.Remotes:FindFirstChild("RequestStartDrag", true)
            
            if dragRemote then
                dragRemote:FireServer(npc)
                task.wait(0.3)
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    npc:BreakJoints()
                end
            end
        end
    end)
end

-- 5. Cập nhật callback cho Kill Aura
AimbotTab:AddToggle("KillAuraToggle", {
    Title = "Bật Kill Aura (Fixed)",
    Description = "Đã fix lỗi và thêm kiểm tra an toàn",
    Default = false,
    Callback = function(state)
        KillAura.Enabled = state
        if state then
            coroutine.wrap(function()
                while KillAura.Enabled do
                    SafeExecuteKillAura()
                    task.wait(KillAura.Cooldown)
                end
            end)()
        end
    end
})

-- 6. Thêm nút reset scroll về đầu
local function AddScrollResetButton(tab)
    local resetBtn = Instance.new("TextButton")
    resetBtn.Text = "↑"
    resetBtn.Size = UDim2.new(0, 30, 0, 30)
    resetBtn.Position = UDim2.new(1, -35, 1, -35)
    resetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    resetBtn.TextColor3 = Color3.white
    resetBtn.Font = Enum.Font.SourceSansBold
    resetBtn.TextSize = 18
    resetBtn.Parent = tab.Container.Parent
    
    resetBtn.MouseButton1Click:Connect(function()
        TweenService:Create(tab.Container, TweenInfo.new(0.3), {CanvasPosition = Vector2.new(0, 0)}):Play()
    end)
end

-- Áp dụng cho tất cả các tab
for _, tab in pairs(Window.Tabs) do
    AddScrollResetButton(tab)
end
