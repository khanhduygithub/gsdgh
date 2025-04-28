repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))() 

local Window = Fluent:CreateWindow({
    Title = "Dead Rails",
    SubTitle = "Advanced Cheat Menu",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})

-- ========== CÁC TAB ==========
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local AimbotTab = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" })
local EspTab = Window:AddTab({ Title = "ESP", Icon = "eye" })
local TeleportTab = Window:AddTab({ Title = "Teleport", Icon = "map-pin" })

-- ========== MAIN TAB ==========
local MainSection = MainTab:AddSection("Auto Features")

-- Auto Bond
local autoBond = false
MainTab:AddToggle("AutoBond", {
    Title = "Auto Collect Bond",
    Description = "Tự động nhặt Bond gần bạn",
    Default = false,
    Callback = function(state)
        autoBond = state
        while autoBond do
            local bond = workspace:FindFirstChild("RuntimeItems") and workspace.RuntimeItems:FindFirstChild("Bond")
            if bond then
                local args = { bond }
                game:GetService("ReplicatedStorage").Packages.RemotePromise.Remotes.C_ActivateObject:FireServer(unpack(args))
            end
            task.wait(0.5)
        end
    end
})

-- Fullbright
local fullbrightEnabled = false
local function enableFullbright()
    if not fullbrightEnabled then
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        fullbrightEnabled = true
    end
end

local function disableFullbright()
    if fullbrightEnabled then
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
        fullbrightEnabled = false
    end
end

MainTab:AddToggle("Fullbright", {
    Title = "Fullbright",
    Description = "Bật sáng toàn bộ bản đồ",
    Default = false,
    Callback = function(state)
        if state then
            enableFullbright()
        else
            disableFullbright()
        end
    end
})

-- Noclip
local noclipEnabled = false
local noclipConnection

local function noclipLoop()
    if game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

MainTab:AddToggle("Noclip", {
    Title = "Noclip",
    Description = "Đi xuyên qua vật thể",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        if noclipEnabled then
            noclipConnection = game:GetService("RunService").Stepped:Connect(noclipLoop)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
            end
        end
    end
})

-- ========== AIMBOT TAB ==========
local AimbotSection = AimbotTab:AddSection("Aimbot Settings")

-- Cài đặt Aimbot
local Settings = {
    Enabled = false,
    FOV = 120,
    Smoothness = 0.65,
    Prediction = 0.02
}

-- Khởi tạo FOV Circle
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(128, 0, 128)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.FOV
FOVCircle.Position = Camera.ViewportSize / 2

-- Biến và tham số
local ValidNPCs = {}
local RaycastParams = RaycastParams.new()
RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}

-- Các hàm chức năng
local function isNPC(model)
    return model:IsA("Model")
        and model:FindFirstChild("Humanoid")
        and model.Humanoid.Health > 0
        and model:FindFirstChild("Head")
        and model:FindFirstChild("HumanoidRootPart")
        and not Players:GetPlayerFromCharacter(model)
        and model.Name ~= "Unicorn"
        and model.Name ~= "Model_Horse"
end

local function updateNPCs()
    local temp = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isNPC(obj) then
            table.insert(temp, obj)
        end
    end
    ValidNPCs = temp
end

local function predictPos(target)
    local root = target:FindFirstChild("HumanoidRootPart")
    local head = target:FindFirstChild("Head")
    if not root or not head then return nil end

    local velocity = root.Velocity
    local predictedRoot = root.Position + velocity * Settings.Prediction
    local headOffset = head.Position - root.Position

    return predictedRoot + headOffset
end

local function getClosestTarget()
    local closestTarget = nil
    local minDistance = math.huge
    local center = Camera.ViewportSize / 2

    for _, npc in ipairs(ValidNPCs) do
        if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local predicted = predictPos(npc)
            if predicted then
                local screenPos, onScreen = Camera:WorldToViewportPoint(predicted)
                if onScreen and screenPos.Z > 0 then
                    local ray = Workspace:Raycast(Camera.CFrame.Position, (predicted - Camera.CFrame.Position).Unit * 1000, RaycastParams)
                    if ray and ray.Instance:IsDescendantOf(npc) then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if distance < minDistance and distance < Settings.FOV then
                            minDistance = distance
                            closestTarget = npc
                        end
                    end
                end
            end
        end
    end

    return closestTarget
end

local function aimAt(targetPos)
    local camCF = Camera.CFrame
    local direction = (targetPos - camCF.Position).Unit
    local newLookVector = camCF.LookVector:Lerp(direction, Settings.Smoothness)
    Camera.CFrame = CFrame.new(camCF.Position, camCF.Position + newLookVector)
end

-- Thêm các control vào UI
AimbotTab:AddToggle("AimbotEnabled", {
    Title = "Bật Aimbot",
    Description = "Tự động ngắm vào mục tiêu",
    Default = false,
    Callback = function(state)
        Settings.Enabled = state
        FOVCircle.Visible = state
    end
})

AimbotTab:AddSlider("FOVSize", {
    Title = "Kích thước FOV",
    Description = "Điều chỉnh phạm vi phát hiện",
    Default = 120,
    Min = 90,
    Max = 180,
    Rounding = 1,
    Callback = function(value)
        Settings.FOV = value
    end
})

AimbotTab:AddSlider("Smoothness", {
    Title = "Độ mượt",
    Description = "Điều chỉnh độ mượt khi ngắm",
    Default = 65,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        Settings.Smoothness = value / 100
    end
})

AimbotTab:AddSlider("Prediction", {
    Title = "Độ dự đoán",
    Description = "Điều chỉnh dự đoán di chuyển",
    Default = 2,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(value)
        Settings.Prediction = value / 100
    end
})

-- Vòng lặp chính
local lastUpdate = 0
local UPDATE_RATE = 0.3

RunService.Heartbeat:Connect(function(dt)
    -- Cập nhật FOV Circle
    FOVCircle.Position = Camera.ViewportSize / 2
    FOVCircle.Radius = Settings.FOV * (Camera.ViewportSize.Y / 1080)
    FOVCircle.Visible = Settings.Enabled

    -- Cập nhật danh sách NPC
    lastUpdate = lastUpdate + dt
    if lastUpdate >= UPDATE_RATE then
        updateNPCs()
        lastUpdate = 0
    end

    -- Kích hoạt aimbot
    if Settings.Enabled then
        local target = getClosestTarget()
        if target then
            local predictedPos = predictPos(target)
            if predictedPos then
                aimAt(predictedPos)
            end
        end
    end
end)

-- Tự động xóa NPC đã chết
Workspace.DescendantRemoving:Connect(function(descendant)
    if table.find(ValidNPCs, descendant) then
        for i = #ValidNPCs, 1, -1 do
            if ValidNPCs[i] == descendant then
                table.remove(ValidNPCs, i)
                break
            end
        end
    end
end)

-- ========== CÁC TAB KHÁC ==========
EspTab:AddSection({ Title = "ESP Settings" })
TeleportTab:AddSection({ Title = "Teleport Locations" })

EspTab:AddParagraph({
    Title = "Thông báo",
    Content = "Chức năng ESP sẽ được thêm sau"
})

TeleportTab:AddParagraph({
    Title = "Thông báo",
    Content = "Các điểm teleport sẽ được thêm sau"
})
