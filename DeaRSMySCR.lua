task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader"))()
end)
task.spawn(function()
local espColor = Color3.fromRGB(255, 255, 255) -- Màu chữ trắng
local outlineColor = Color3.fromRGB(128, 128, 128) -- Viền xám
local highlightColor = Color3.fromRGB(255, 223, 0) -- Màu vàng cho highlight

-- Tạo ESP
local function createESP(item)
    -- Tạo BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BondESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.MaxDistance = math.huge  -- Hiển thị ở khoảng cách vô hạn
    billboard.Parent = item

    -- Tạo TextLabel
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Text = "💰 BOND 💰"
    textLabel.TextColor3 = espColor
    textLabel.TextStrokeColor3 = outlineColor
    textLabel.TextStrokeTransparency = 0
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextSize = 10

    -- Tạo Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "BondHighlight"
    highlight.FillColor = highlightColor
    highlight.FillTransparency = 0.5 -- Độ trong suốt vừa đủ
    highlight.OutlineColor = highlightColor
    highlight.OutlineTransparency = 0
    highlight.Parent = item
end

-- Kiểm tra và thêm ESP + Highlight
local function checkForBonds()
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Model") and item.Name == "Bond" and not item:FindFirstChild("BondESP") then
            createESP(item)
        end
    end
end

-- Lắng nghe khi Bond mới xuất hiện
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant.Name == "Bond" then
        createESP(descendant)
    end
end)

-- Khởi động kiểm tra ban đầu
checkForBonds()
end)

task.spawn(function() -- Made by yee_kunkun (enhanced by Hỗ trợ 🔨3)
local fov = 150
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer

-- Vòng tròn FOV
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

local isAiming = false
local validNPCs = {}
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

-- Giao diện
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 130, 0, 45)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "AIMBOT: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui

-- Hiển thị tên NPC
local NPCNameLabel = Instance.new("TextLabel")
NPCNameLabel.Size = UDim2.new(0, 200, 0, 30)
NPCNameLabel.Position = UDim2.new(0, 10, 1, -40) -- Góc trái dưới cùng
NPCNameLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NPCNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NPCNameLabel.Text = "NPC: None"
NPCNameLabel.TextSize = 14
NPCNameLabel.Font = Enum.Font.GothamBold
NPCNameLabel.Parent = ScreenGui

-- Âm thanh thông báo khi bật/tắt
local Sound = Instance.new("Sound", game.SoundService)
Sound.SoundId = "rbxassetid://6026984224"

-- Kiểm tra NPC hợp lệ
local function isNPC(obj)
    return obj:IsA("Model") 
    and obj:FindFirstChild("Humanoid") 
    and obj.Humanoid.Health > 0 
    and obj:FindFirstChild("Head") 
    and obj:FindFirstChild("HumanoidRootPart") 
    and not game:GetService("Players"):GetPlayerFromCharacter(obj)
    and obj.Name ~= "Unicorn"
    and obj.Name ~= "Model_Horse"
end

-- Cập nhật danh sách NPC
local function updateNPCs()
    validNPCs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            table.insert(validNPCs, obj)
        end
    end
end

-- Cập nhật vị trí FOV
local function updateDrawings()
    FOVring.Position = Cam.ViewportSize / 2
    FOVring.Radius = fov * (Cam.ViewportSize.Y / 1080)
end

-- Thuật toán dự đoán vị trí NPC
local function predictPos(target)
    local rootPart = target:FindFirstChild("HumanoidRootPart")
    local head = target:FindFirstChild("Head")
    if not rootPart or not head then 
        return head and head.Position or rootPart and rootPart.Position 
    end
    local velocity = rootPart.Velocity
    local predictionTime = 0.02
    local basePosition = rootPart.Position + velocity * predictionTime
    local headOffset = head.Position - rootPart.Position
    return basePosition + headOffset
end

-- Tìm mục tiêu gần nhất trong FOV
local function getTarget()
    local nearest, minDistance = nil, math.huge
    local viewportCenter = Cam.ViewportSize / 2
    raycastParams.FilterDescendantsInstances = {Player.Character}

    for _, npc in ipairs(validNPCs) do
        local predictedPos = predictPos(npc)
        local screenPos, visible = Cam:WorldToViewportPoint(predictedPos)
        if visible and screenPos.Z > 0 then
            local ray = workspace:Raycast(
                Cam.CFrame.Position, 
                (predictedPos - Cam.CFrame.Position).Unit * 1000, 
                raycastParams
            )
            if ray and ray.Instance:IsDescendantOf(npc) then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                if distance < minDistance and distance < fov then
                    minDistance = distance
                    nearest = npc
                end
            end
        end
    end
    return nearest
end

-- Điều chỉnh góc nhìn để aim
local function aim(targetPosition)
    local currentCF = Cam.CFrame
    local targetDirection = (targetPosition - currentCF.Position).Unit
    local smoothFactor = 0.65
    local newLookVector = currentCF.LookVector:Lerp(targetDirection, smoothFactor)
    Cam.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
end

-- Vòng lặp chính
local lastUpdate = 0
local UPDATE_INTERVAL = 0.3

RunService.Heartbeat:Connect(function(dt)
    updateDrawings()
    lastUpdate = lastUpdate + dt
    if lastUpdate >= UPDATE_INTERVAL then
        updateNPCs()
        lastUpdate = 0
    end

    if isAiming then
        local target = getTarget()
        if target then
            local predictedPosition = predictPos(target)
            aim(predictedPosition)
            NPCNameLabel.Text = "NPC: " .. target.Name
        else
            NPCNameLabel.Text = "NPC: None"
        end
    else
        NPCNameLabel.Text = "NPC: None"
    end
end)

-- Nút bật/tắt
ToggleButton.MouseButton1Click:Connect(function()
    isAiming = not isAiming
    FOVring.Visible = isAiming
    ToggleButton.Text = "AIMBOT: " .. (isAiming and "ON" or "OFF")
    ToggleButton.TextColor3 = isAiming and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    -- Phát âm thanh khi chuyển đổi
    Sound:Play()
end)

-- Kéo thả nút (giới hạn trong màn hình)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    local newX = math.clamp(startPos.X.Offset + delta.X, 0, Cam.ViewportSize.X - ToggleButton.AbsoluteSize.X)
    local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, Cam.ViewportSize.Y - ToggleButton.AbsoluteSize.Y)
    ToggleButton.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

end)

task.spawn(function()
local Workspace = game:GetService("Workspace")

-- Màu sắc
local colorSnakeOil = Color3.fromRGB(0, 160, 0) -- Xanh lá đậm
local colorBandage = Color3.fromRGB(255, 0, 195) -- Hồng đậm

local outlineColor = Color3.fromRGB(0, 0, 0) -- Viền đen

-- Hàm tạo ESP
local function createItemESP(model, labelText, fillColor)
    if model:FindFirstChild("ItemESP") then return end

    -- BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.MaxDistance = math.huge
    billboard.Parent = model.PrimaryPart

    -- TextLabel
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Text = labelText
    textLabel.TextColor3 = fillColor
    textLabel.TextStrokeColor3 = outlineColor
    textLabel.TextStrokeTransparency = 0
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextSize = 15
    textLabel.Font = Enum.Font.GothamBold

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemESPHighlight"
    highlight.FillColor = fillColor
    highlight.FillTransparency = 1
    highlight.OutlineColor = fillColor
    highlight.OutlineTransparency = 0
    highlight.Parent = model
end

-- Hàm kiểm tra và gán ESP
local function handleItem(model)
    if model:IsA("Model") and model.PrimaryPart then
        if model.Name == "Snake Oil" then
            createItemESP(model, "Snake Oil", colorSnakeOil)
        elseif model.Name == "Bandage" then
            createItemESP(model, "Bandage", colorBandage)
        end
    end
end

-- Quét ban đầu
for _, item in ipairs(Workspace:GetDescendants()) do
    task.spawn(function()
        if item:IsA("Model") then
            if not item.PrimaryPart then
                item:GetPropertyChangedSignal("PrimaryPart"):Wait()
            end
            handleItem(item)
        end
    end)
end

-- Theo dõi thêm mới
Workspace.DescendantAdded:Connect(function(descendant)
    task.spawn(function()
        if descendant:IsA("Model") then
            if not descendant.PrimaryPart then
                descendant:GetPropertyChangedSignal("PrimaryPart"):Wait()
            end
            handleItem(descendant)
        end
    end)
end)
end)

task.spawn(function()
local Workspace = game:GetService("Workspace")

-- Cấu hình màu sắc
local textColor = Color3.fromRGB(0, 0, 0) -- Màu chữ đen
local outlineColor = Color3.fromRGB(255, 255, 255) -- Viền trắng
local highlightColor = Color3.fromRGB(0, 0, 0) -- Highlight đen

-- Hàm tạo ESP
local function createCoalESP(model)
    if model:FindFirstChild("CoalESP") then return end

    -- BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CoalESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.MaxDistance = math.huge
    billboard.Parent = model.PrimaryPart

    -- TextLabel
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Text = "Coal"
    textLabel.TextColor3 = textColor
    textLabel.TextStrokeColor3 = outlineColor
    textLabel.TextStrokeTransparency = 0
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextSize = 15 -- Theo yêu cầu
    textLabel.Font = Enum.Font.GothamBold

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "CoalHighlight"
    highlight.FillColor = highlightColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Viền Highlight trắng
    highlight.OutlineTransparency = 0
    highlight.Parent = model
end

-- Hàm xử lý vật phẩm
local function handleCoal(model)
    if model:IsA("Model") and model.PrimaryPart and model.Name == "Coal" then
        createCoalESP(model)
    end
end

-- Quét ban đầu
for _, item in ipairs(Workspace:GetDescendants()) do
    task.spawn(function()
        if item:IsA("Model") then
            if not item.PrimaryPart then
                item:GetPropertyChangedSignal("PrimaryPart"):Wait()
            end
            handleCoal(item)
        end
    end)
end

-- Theo dõi vật phẩm mới
Workspace.DescendantAdded:Connect(function(descendant)
    task.spawn(function()
        if descendant:IsA("Model") then
            if not descendant.PrimaryPart then
                descendant:GetPropertyChangedSignal("PrimaryPart"):Wait()
            end
            handleCoal(descendant)
        end
    end)
end)
end)

task.spawn(function()
   local espColor = Color3.fromRGB(0, 255, 0) -- Chữ xanh
    local outlineColor = Color3.fromRGB(255, 255, 255) -- Viền trắng
    local highlightColor = Color3.fromRGB(0, 255, 0) -- Màu xanh lá

    -- Tạo ESP
    local function createESP(item)
        local maskPart = item:FindFirstChild("Mask")
        if not maskPart then return end -- Nếu không tìm thấy "Mask", thoát

        -- Tạo BillboardGui
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "StrangeMaskESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.MaxDistance = math.huge
        billboard.Parent = maskPart

        -- Tạo TextLabel
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.Text = "🟩 StrangeMask"
        textLabel.TextColor3 = espColor
        textLabel.TextStrokeColor3 = outlineColor
        textLabel.TextStrokeTransparency = 0
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.TextSize = 15
        textLabel.Font = Enum.Font.SourceSansBold

        -- Tạo Highlight
        local highlight = Instance.new("Highlight")
        highlight.Name = "StrangeMaskHighlight"
        highlight.FillColor = highlightColor
        highlight.FillTransparency = 1
        highlight.OutlineColor = outlineColor
        highlight.OutlineTransparency = 0
        highlight.Parent = item
    end

    -- Kiểm tra và thêm ESP + Highlight
    local function checkForStrangeMasks()
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Model") and item.Name == "StrangeMask" then
                if not item:FindFirstChild("StrangeMaskESP") then
                    createESP(item)
                end
            end
        end
    end

    -- Lắng nghe khi StrangeMask mới xuất hiện
    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "StrangeMask" then
            createESP(descendant)
        end
    end)

    -- Xóa ESP khi StrangeMask biến mất
    workspace.DescendantRemoving:Connect(function(descendant)
        if descendant:IsA("Model") and descendant.Name == "StrangeMask" then
            if descendant:FindFirstChild("StrangeMaskESP") then
                descendant.StrangeMaskESP:Destroy()
            end
            if descendant:FindFirstChild("StrangeMaskHighlight") then
                descendant.StrangeMaskHighlight:Destroy()
            end
        end
    end)

    -- Khởi động kiểm tra ban đầu
    checkForStrangeMasks()
end)
