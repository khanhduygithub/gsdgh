--// UI + Hack cho Dead Rails by Thichhack03

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local noclip = false
local espOn = false

-- Xoá UI cũ nếu có
if CoreGui:FindFirstChild("VNMenu") then
    CoreGui:FindFirstChild("VNMenu"):Destroy()
end

-- UI setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "VNMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 100, 0, 100) -- hình vuông 3mm ~ 100x100px
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

-- Cờ VN
local Flag = Instance.new("TextLabel", Frame)
Flag.Size = UDim2.new(1, 0, 0, 30)
Flag.Text = "🇻🇳"
Flag.TextScaled = true
Flag.BackgroundTransparency = 1
Flag.TextColor3 = Color3.new(1,1,1)

-- Nút Noclip
local NoclipBtn = Instance.new("TextButton", Frame)
NoclipBtn.Position = UDim2.new(0, 5, 0, 35)
NoclipBtn.Size = UDim2.new(1, -10, 0, 20)
NoclipBtn.Text = "Noclip: OFF"

-- Nút ESP
local ESPBtn = Instance.new("TextButton", Frame)
ESPBtn.Position = UDim2.new(0, 5, 0, 60)
ESPBtn.Size = UDim2.new(1, -10, 0, 20)
ESPBtn.Text = "ESP: OFF"

-- Nút TP đến cuối
local TPBtn = Instance.new("TextButton", Frame)
TPBtn.Position = UDim2.new(0, 5, 0, 85)
TPBtn.Size = UDim2.new(1, -10, 0, 20)
TPBtn.Text = "TP Cuối"

-- Noclip Toggle
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

-- ESP Function
local function highlightTarget(target, color)
    if target:FindFirstChild("Highlight") then return end
    local hl = Instance.new("Highlight", target)
    hl.FillColor = color
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.2
end

local function removeHighlights()
    for _, plr in pairs(game:GetService("Workspace"):GetDescendants()) do
        if plr:IsA("Model") and plr:FindFirstChild("Highlight") then
            plr.Highlight:Destroy()
        end
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    ESPBtn.Text = "ESP: " .. (espOn and "ON" or "OFF")
    if not espOn then
        removeHighlights()
    end
end)
-- ESP loop
RunService.RenderStepped:Connect(function()
    if not espOn then return end

    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") then
            local name = model.Name:lower()
            local color = nil
            if name:find("zombie") then color = Color3.fromRGB(0,255,0)
            elseif name:find("ma sói") or name:find("werewolf") then color = Color3.fromRGB(255, 0, 127)
            elseif name:find("ma cà rồng") or name:find("vampire") then color = Color3.fromRGB(128,0,255)
            elseif name:find("cướp") or name:find("robber") then color = Color3.fromRGB(255, 255, 0)
            elseif name:find("sói") then color = Color3.fromRGB(255, 0, 0)
            elseif Players:FindFirstChild(model.Name) and model ~= LocalPlayer.Character then
                color = Color3.fromRGB(0, 170, 255)
            end
            if color then highlightTarget(model, color) end
        end
    end
end)

-- Teleport cuối map (thay đổi vị trí nếu cần)
TPBtn.MouseButton1Click:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        -- Vị trí cuối tùy map, đây chỉ là ví dụ
        root.CFrame = CFrame.new(9999, 100, 0)
    end
end)
local fov = 90
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer

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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "AIMBOT: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui

local function isNPC(obj)
    return obj:IsA("Model") 
        and obj:FindFirstChild("Humanoid")
        and obj.Humanoid.Health > 0
        and obj:FindFirstChild("Head")
        and obj:FindFirstChild("HumanoidRootPart")
        and not game:GetService("Players"):GetPlayerFromCharacter(obj)
end

local function updateNPCs()
    local tempTable = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            tempTable[obj] = true
        end
    end
    for i = #validNPCs, 1, -1 do
        if not tempTable[validNPCs[i]] then
            table.remove(validNPCs, i)
        end
    end
    for obj in pairs(tempTable) do
        if not table.find(validNPCs, obj) then
            table.insert(validNPCs, obj)
        end
    end
end

local function handleDescendant(descendant)
    if isNPC(descendant) then
        table.insert(validNPCs, descendant)
        local humanoid = descendant:WaitForChild("Humanoid")
        humanoid.Destroying:Connect(function()
            for i = #validNPCs, 1, -1 do
                if validNPCs[i] == descendant then
                    table.remove(validNPCs, i)
                    break
                end
            end
        end)
    end
end

workspace.DescendantAdded:Connect(handleDescendant)

local function updateDrawings()
    FOVring.Position = Cam.ViewportSize / 2
    FOVring.Radius = fov * (Cam.ViewportSize.Y / 1080)
end

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

local function getTarget()
    local nearest = nil
    local minDistance = math.huge
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

local function aim(targetPosition)
    local currentCF = Cam.CFrame
    local targetDirection = (targetPosition - currentCF.Position).Unit
    local smoothFactor = 0.581
    local newLookVector = currentCF.LookVector:Lerp(targetDirection, smoothFactor)
    Cam.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
end

local heartbeat = RunService.Heartbeat
local lastUpdate = 0
local UPDATE_INTERVAL = 0.4

heartbeat:Connect(function(dt)
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
        end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    isAiming = not isAiming
    FOVring.Visible = isAiming
    ToggleButton.Text = "AIMBOT: " .. (isAiming and "ON" or "OFF")
    ToggleButton.TextColor3 = isAiming and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

updateNPCs()
workspace.DescendantRemoved:Connect(function(descendant)
    if isNPC(descendant) then
        for i = #validNPCs, 1, -1 do
            if validNPCs[i] == descendant then
                table.remove(validNPCs, i)
                break
            end
        end
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function()
    FOVring:Remove()
    ScreenGui:Destroy()
end)
