--// Made by yee_kunkun
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "Dead Rails Hub - by yee_kunkun",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DeadRailsHub"
})

-- Variables cho Aimbot
local fov = 90
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer

local isAiming = false
local validNPCs = {}
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

-- Hàm Aimbot cơ bản
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

workspace.DescendantAdded:Connect(function(descendant)
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
end)

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

-- Kết nối heartbeat
RunService.Heartbeat:Connect(function(dt)
    FOVring.Position = Cam.ViewportSize / 2
    FOVring.Radius = fov * (Cam.ViewportSize.Y / 1080)

    if isAiming then
        local target = getTarget()
        if target then
            local predictedPosition = predictPos(target)
            aim(predictedPosition)
        end
    end
end)

--// Tạo các tab
local AttackTab = Window:MakeTab({
    Name = "Attack",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local UtilityTab = Window:MakeTab({
    Name = "Utility",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

--// Attack Tab: Nút bật Aimbot
AttackTab:AddToggle({
    Name = "Aimbot (NPC Headshot)",
    Default = false,
    Callback = function(Value)
        isAiming = Value
        FOVring.Visible = Value
    end
})

AttackTab:AddButton({
    Name = "Kill Aura (Fake)",
    Callback = function()
        print("Kill Aura bật lên (chưa code thêm nhé)")
    end
})

--// Teleport Tab
TeleportTab:AddButton({
    Name = "Teleport tới Shop",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 5, 0))
    end
})

TeleportTab:AddButton({
    Name = "Teleport tới Train",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(100, 5, 100))
    end
})

--// Utility Tab
UtilityTab:AddButton({
    Name = "Speed Hack",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
})

UtilityTab:AddButton({
    Name = "Reset Speed",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
})

--// Cuối cùng: Init UI
OrionLib:Init()

-- Cập nhật NPCs ban đầu
updateNPCs()
