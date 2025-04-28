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

-- ========== ESP TAB ==========
local EspSection = EspTab:AddSection("ESP Settings")

-- Cài đặt ESP
local ESP = {
    Enabled = false,
    Mode = "Boxes",  -- Các chế độ: "Boxes", "Highlight"
    Color = Color3.fromRGB(255, 0, 0),  -- Màu sắc của ESP
    MaxDistance = 500,  -- Khoảng cách tối đa để hiển thị ESP
    ShowHP = true,
    ShowHPText = true,
    ShowName = true,
    ShowDistance = true,
    IgnoreDead = true,  -- Bỏ qua các NPC đã chết
    HPPosition = "Horizontal",  -- Vị trí thanh máu: "Horizontal" hoặc "Vertical"
    Boxes = {},
    Highlights = {},
    Texts = {},
}

local CoreGui = game:GetService("CoreGui")
local MyCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local ESPConnection = nil

-- Thêm các control vào UI để cấu hình ESP
EspSection:AddToggle("ESPEnabled", {
    Title = "Bật ESP",
    Description = "Hiển thị ESP cho các NPC",
    Default = false,
    Callback = function(state)
        ESP.Enabled = state
        ToggleESP(state)
    end
})

EspSection:AddDropdown("ESPModes", {
    Title = "Chế độ ESP",
    Items = {"Boxes", "Highlight"},
    Default = 1,
    Callback = function(selected)
        ESP.Mode = selected
    end
})

EspSection:AddColorPicker("ESPColor", {
    Title = "Màu ESP",
    Default = ESP.Color,
    Callback = function(color)
        ESP.Color = color
    end
})

EspSection:AddSlider("ESPMaxDistance", {
    Title = "Khoảng cách ESP",
    Description = "Điều chỉnh khoảng cách tối đa để hiển thị ESP",
    Default = ESP.MaxDistance,
    Min = 50,
    Max = 1000,
    Rounding = 1,
    Callback = function(value)
        ESP.MaxDistance = value
    end
})

EspSection:AddToggle("ShowHP", {
    Title = "Hiển thị thanh máu",
    Description = "Hiển thị thanh máu của NPC",
    Default = true,
    Callback = function(state)
        ESP.ShowHP = state
    end
})

EspSection:AddToggle("ShowHPText", {
    Title = "Hiển thị số máu",
    Description = "Hiển thị số máu của NPC",
    Default = true,
    Callback = function(state)
        ESP.ShowHPText = state
    end
})

EspSection:AddToggle("ShowName", {
    Title = "Hiển thị tên",
    Description = "Hiển thị tên của NPC",
    Default = true,
    Callback = function(state)
        ESP.ShowName = state
    end
})

EspSection:AddToggle("ShowDistance", {
    Title = "Hiển thị khoảng cách",
    Description = "Hiển thị khoảng cách đến NPC",
    Default = true,
    Callback = function(state)
        ESP.ShowDistance = state
    end
})

-- Cập nhật ESP
local function CalculateCharacterSize(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return Vector3.new(0, 0, 0) end
    
    local root = character.HumanoidRootPart
    local cf = root.CFrame
    local size = root.Size
    
    return Vector3.new(size.X * 2, size.Y * 3, size.Z * 2)
end

local function CreateESP(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = ESP.Color
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    box.ZIndex = 1
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = CoreGui
    highlight.Adornee = character
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = ESP.Color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = ESP.Color
    highlight.OutlineTransparency = 0
    
    local hpBar = Drawing.new("Line")
    hpBar.Visible = false
    hpBar.Color = Color3.fromRGB(0, 255, 0)
    hpBar.Thickness = 2
    hpBar.ZIndex = 2
    
    local hpText = Drawing.new("Text")
    hpText.Visible = false
    hpText.Color = Color3.fromRGB(255, 255, 255)
    hpText.Size = 13
    hpText.Center = true
    hpText.Outline = true
    hpText.ZIndex = 3
    
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Size = 14
    nameText.Center = true
    nameText.Outline = true
    nameText.ZIndex = 3
    
    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Color = Color3.fromRGB(255, 255, 255)
    distText.Size = 12
    distText.Center = true
    distText.Outline = true
    distText.ZIndex = 3
    
    ESP.Boxes[character] = box
    ESP.Highlights[character] = highlight
    ESP.Texts[character] = {
        hpBar = hpBar,
        hpText = hpText,
        nameText = nameText,
        distText = distText
    }
end

local function UpdateESP()
    if not ESP.Enabled then return end
    
    local cameraPos = Camera.CFrame.Position
    
    for character, box in pairs(ESP.Boxes) do
        if character and character.Parent and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if ESP.IgnoreDead and humanoid and humanoid.Health <= 0 then
                box.Visible = false
                if ESP.Highlights[character] then
                    ESP.Highlights[character].Enabled = false
                end
                local texts = ESP.Texts[character]
                if texts then
                    texts.hpBar.Visible = false
                    texts.hpText.Visible = false
                    texts.nameText.Visible = false
                    texts.distText.Visible = false
                end
                continue
            end
            
            local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local distance = (rootPart.Position - cameraPos).Magnitude
            
            if onScreen and distance <= ESP.MaxDistance then
                local size = CalculateCharacterSize(character)
                local scale = 1000 / position.Z
                local width = math.max(20, size.X * scale)
                local height = math.max(30, size.Y * scale)
                
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(position.X - width/2, position.Y - height/2)
                box.Visible = ESP.Mode == "Boxes"
                box.Color = ESP.Color
                
                local highlight = ESP.Highlights[character]
                if highlight then
                    highlight.Enabled = ESP.Mode == "Highlight"
                    highlight.Adornee = character
                    highlight.FillColor = ESP.Color
                    highlight.OutlineColor = ESP.Color
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                end
                
                local texts = ESP.Texts[character]
                if texts then
                    if ESP.ShowHP and humanoid then
                        local hpPercent = humanoid.Health / humanoid.MaxHealth
                        local barLength = width * hpPercent
                        
                        if ESP.HPPosition == "Horizontal" then
                            texts.hpBar.From = Vector2.new(position.X - width/2, position.Y - height/2 - 10)
                            texts.hpBar.To = Vector2.new(position.X - width/2 + barLength, position.Y - height/2 - 10)
                        else
                            texts.hpBar.From = Vector2.new(position.X - width/2 - 10, position.Y + height/2)
                            texts.hpBar.To = Vector2.new(position.X - width/2 - 10, position.Y + height/2 - height * hpPercent)
                        end
                        
                        texts.hpBar.Color = Color3.fromHSV(hpPercent * 0.3, 1, 1)
                        texts.hpBar.Visible = true
                    else
                        texts.hpBar.Visible = false
                    end
                    
                    if ESP.ShowHPText and humanoid then
                        texts.hpText.Text = string.format("%d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                        texts.hpText.Position = Vector2.new(position.X, position.Y - height/2 - 25)
                        texts.hpText.Visible = true
                    else
                        texts.hpText.Visible = false
                    end
                    
                    if ESP.ShowName then
                        texts.nameText.Text = character.Name
                        texts.nameText.Position = Vector2.new(position.X, position.Y + height/2 + 5)
                        texts.nameText.Visible = true
                    else
                        texts.nameText.Visible = false
                    end
                    
                    if ESP.ShowDistance then
                        texts.distText.Text = string.format("%d studs", math.floor(distance))
                        texts.distText.Position = Vector2.new(position.X, position.Y + height/2 + 20)
                        texts.distText.Visible = true
                    else
                        texts.distText.Visible = false
                    end
                end
            else
                box.Visible = false
                if ESP.Highlights[character] then
                    ESP.Highlights[character].Enabled = false
                end
                
                local texts = ESP.Texts[character]
                if texts then
                    texts.hpBar.Visible = false
                    texts.hpText.Visible = false
                    texts.nameText.Visible = false
                    texts.distText.Visible = false
                end
            end
        else
            box.Visible = false
            box:Remove()
            ESP.Boxes[character] = nil
            
            if ESP.Highlights[character] then
                ESP.Highlights[character]:Destroy()
                ESP.Highlights[character] = nil
            end
            
            local texts = ESP.Texts[character]
            if texts then
                texts.hpBar:Remove()
                texts.hpText:Remove()
                texts.nameText:Remove()
                texts.distText:Remove()
                ESP.Texts[character] = nil
            end
        end
    end
end

local function ClearESP()
    for character, box in pairs(ESP.Boxes) do
        box:Remove()
    end
    
    for character, highlight in pairs(ESP.Highlights) do
        highlight:Destroy()
    end
    
    for character, texts in pairs(ESP.Texts) do
        texts.hpBar:Remove()
        texts.hpText:Remove()
        texts.nameText:Remove()
        texts.distText:Remove()
    end
    
    ESP.Boxes = {}
    ESP.Highlights = {}
    ESP.Texts = {}
end

-- Tắt hoặc bật ESP
local function ToggleESP(enabled)
    ESP.Enabled = enabled
    if not enabled then
        ClearESP()
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
    else
        for _, model in ipairs(Workspace:GetChildren()) do
            if model:IsA("Model") and model ~= MyCharacter and model:FindFirstChildOfClass("Humanoid") then
                CreateESP(model)
            end
        end
        
        if not ESPConnection then
            ESPConnection = Workspace.ChildAdded:Connect(function(child)
                if ESP.Enabled and child:IsA("Model") and child ~= MyCharacter and child:FindFirstChildOfClass("Humanoid") then
                    CreateESP(child)
                end
            end)
        end
        
        -- Create update loop
        local updateLoop
        updateLoop = RunService.Heartbeat:Connect(function()
            if ESP.Enabled then
                UpdateESP()
            else
                updateLoop:Disconnect()
            end
        end)
    end
end

-- ========== CÁC TAB KHÁC ==========
TeleportTab:AddSection({ Title = "Teleport Locations" })

TeleportTab:AddParagraph({
    Title = "Thông báo",
    Content = "Các điểm teleport sẽ được thêm sau"
})