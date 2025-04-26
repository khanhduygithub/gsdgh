-- Загрузка Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local scrVer = "0.5.2 STABLE"

-- Создание окна
local Window = Rayfield:CreateWindow({
    Name = "Dead Rails Script",
    LoadingTitle = "Script Loading",
    LoadingSubtitle = "By Sanya",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "UltraAimbot",
        FileName = "Config.json"
    },
    KeySystem = true,
    KeySettings = {
      Title = "Dead Rails Script",
      Subtitle = "Enter Key To Get Access Of The Script",
      Note = "Ask Me For Key",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"r9azGxw4"},
   },
})

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Переменные
local MyCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local NPCList = {}
local CharacterAddedConnection = nil

-- Настройки ESP
local ESP = {
    Enabled = false,
    Mode = "Boxes",
    Color = Color3.fromRGB(255, 255, 255),
    Boxes = {},
    Highlights = {},
    Texts = {},
    ShowHP = true,
    HPPosition = "Horizontal",
    ShowHPText = true,
    ShowName = true,
    ShowDistance = true,
    MaxDistance = 1000,
    UpdateRate = 0.05,
    IgnoreDead = true,
    LastUpdate = 0
}

-- Настройки утилит
local Settings = {
    fullbright = false,
    Noclip = false,
    AntiFall = false,
    AntiAFK = false,
}

-- Табы
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local FullbrightTab = Window:CreateTab("Fullbright", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)
local TeleTab = Window:CreateTab("TELEPORT", 4483362458)
local ChangelogsTab = Window:CreateTab("Changelogs", 4483362458)

-- Функция для обработки смерти/возрождения персонажа
local function SetupCharacter()
    if MyCharacter then
        local humanoid = MyCharacter:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                MyCharacter = LocalPlayer.CharacterAdded:Wait()
                task.wait(0.5)
                SetupCharacter()
            end)
        end
    end
end

-- Функции для ESP
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
    ESP.Boxes = {}
    
    for character, highlight in pairs(ESP.Highlights) do
        highlight:Destroy()
    end
    ESP.Highlights = {}
    
    for character, texts in pairs(ESP.Texts) do
        texts.hpBar:Remove()
        texts.hpText:Remove()
        texts.nameText:Remove()
        texts.distText:Remove()
    end
    ESP.Texts = {}
end

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
    end
end

-- Функция для Anti-AFK
local function ToggleAntiAFK(enabled)
    Settings.AntiAFK = enabled
    if enabled then
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
        end
        AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end)
        Rayfield:Notify({
            Title = "Anti-AFK",
            Content = "Enabled - You won't be kicked for being AFK",
            Duration = 3,
            Image = 4483362458
        })
    else
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
            Rayfield:Notify({
                Title = "Anti-AFK",
                Content = "Disabled",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
end

local FastProximityPromptEnabled = false
local ProximityPromptConnections = {}

local function SetFastProximityPrompt(enabled)
    FastProximityPromptEnabled = enabled
    
    for _, connection in pairs(ProximityPromptConnections) do
        connection:Disconnect()
    end
    ProximityPromptConnections = {}
    
    if enabled then
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end
        end
        
        table.insert(ProximityPromptConnections, workspace.DescendantAdded:Connect(function(descendant)
            if FastProximityPromptEnabled and descendant:IsA("ProximityPrompt") then
                descendant.HoldDuration = 0
            end
        end))
    end
end
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


local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

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

local function enableFullbright()
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
end
AimbotTab:CreateSection("Main")
AimbotTab:CreateToggle({
    Name = "Aimbot", 
    CurrentValue = Settings.Enabled, 
    Callback = function(v) 
        Settings.Enabled = v 
        if not v then 
            Aiming = false
            LockedTarget = nil
        end
    end
})
-- UI элементы
FullbrightTab:CreateToggle({
    Name = "Enable Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        Settings.fullbright = Value
    end,
})

UtilityTab:CreateSection("Noclip")
UtilityTab:CreateToggle({
    Name = "Enable Noclip", 
    CurrentValue = Settings.Noclip, 
    Callback = function(v) 
        Settings.Noclip = v 
    end
})

UtilityTab:CreateSection("Interaction")
UtilityTab:CreateToggle({
    Name = "Fast Proximity Prompt", 
    CurrentValue = false, 
    Callback = function(value)
        SetFastProximityPrompt(value)
    end
})

UtilityTab:CreateSection("Anti-Fall")
UtilityTab:CreateToggle({
    Name = "Anti-Fall Teleport", 
    CurrentValue = Settings.AntiFall, 
    Callback = function(v) 
        Settings.AntiFall = v 
        if v then
            Rayfield:Notify({
                Title = "Anti-Fall",
                Content = "Enabled - You will be teleported back if you fall below Y=-15",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

UtilityTab:CreateSection("Anti-AFK")
UtilityTab:CreateToggle({
    Name = "Anti-AFK", 
    CurrentValue = Settings.AntiAFK, 
    Callback = function(v) 
        ToggleAntiAFK(v)
    end
})

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = ESP.Enabled,
    Callback = function(v)
        ToggleESP(v)
    end
})

ESPTab:CreateDropdown({
    Name = "ESP Mode",
    Options = {"Boxes", "Highlight"},
    CurrentOption = ESP.Mode,
    Callback = function(v)
        ESP.Mode = v
    end
})

ESPTab:CreateColorPicker({
    Name = "ESP Color",
    Color = ESP.Color,
    Callback = function(c)
        ESP.Color = c
    end
})

ESPTab:CreateToggle({
    Name = "Show NPC HP",
    CurrentValue = ESP.ShowHP,
    Callback = function(v)
        ESP.ShowHP = v
    end
})

ESPTab:CreateDropdown({
    Name = "HP Bar Position",
    Options = {"Horizontal", "Vertical"},
    CurrentOption = ESP.HPPosition,
    Callback = function(v)
        ESP.HPPosition = v
    end
})

ESPTab:CreateToggle({
    Name = "Show HP Text",
    CurrentValue = ESP.ShowHPText,
    Callback = function(v)
        ESP.ShowHPText = v
    end
})

ESPTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = ESP.ShowName,
    Callback = function(v)
        ESP.ShowName = v
    end
})

ESPTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = ESP.ShowDistance,
    Callback = function(v)
        ESP.ShowDistance = v
    end
})

ESPTab:CreateToggle({
    Name = "Ignore Dead NPC",
    CurrentValue = ESP.IgnoreDead,
    Callback = function(v)
        ESP.IgnoreDead = v
    end
})

ESPTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 5000},
    Increment = 100,
    CurrentValue = ESP.MaxDistance,
    Callback = function(v)
        ESP.MaxDistance = v
    end
})

TeleTab:CreateToggle({
    Name = "The End",
    CurrentValue = false,
    Callback = function(Value)
        Settings.teleport = Value
    end,
})

ChangelogsTab:CreateSection("Version 0.5.2")
ChangelogsTab:CreateParagraph({
    Title = "ESP System Improvements:",
    Content = [[
- Completely reworked ESP system for better performance
- Added instant detection for newly spawned NPCs
- Fixed Highlight mode rendering issues
- Reduced ESP update time from 0.1s to 0.05s
- Added proper cleanup for removed NPCs
    ]]
})

ChangelogsTab:CreateSection("Version 0.5.1")
ChangelogsTab:CreateParagraph({
    Title = "Previous Update:",
    Content = [[
- Added HP bar system with position options
- Added NPC name and distance displays
- Improved box size calculations
- Added max distance slider
- Various visual improvements
    ]]
})

ChangelogsTab:CreateSection("Version 0.5.0")
ChangelogsTab:CreateParagraph({
    Title = "Initial ESP Release:",
    Content = [[
- Added basic ESP system with two modes
- Implemented Box and Highlight visuals
- Added color customization
- Basic NPC detection system
- Core ESP functionality
    ]]
})

ChangelogsTab:CreateSection("Version 0.4.9")
ChangelogsTab:CreateParagraph({
    Title = "What's New:",
    Content = [[
- Added separate Manual Aim mode
- Fixed aiming toggle issues
- Improved target acquisition logic
- Better notifications system
    ]]
})

ChangelogsTab:CreateSection("Version 0.4.8")
ChangelogsTab:CreateParagraph({
    Title = "What's New:",
    Content = [[
- Optimized Fast Proximity Prompt (no more freeze)
- Added Changelog tab
    ]]
})

ChangelogsTab:CreateSection("Version 0.4.7")
ChangelogsTab:CreateParagraph({
    Title = "What's New:",
    Content = [[
- Added Fast Proximity Prompt toggle to Utility tab
- Performance improvements
    ]]
})

ChangelogsTab:CreateSection("Version 0.4.6")
ChangelogsTab:CreateParagraph({
    Title = "What's New:",
    Content = [[
- Manual Aimbot toggle via key (default: E)
- Aimbot ignores dead NPCs
- Fixed Noclip/Aimbot breaking on death + revive
    ]]
})

ChangelogsTab:CreateSection("Version 0.4.5 BETA")
ChangelogsTab:CreateParagraph({
    Title = "Initial Beta:",
    Content = [[
- Core Aimbot System
- AutoAim, Smoothing, FOV settings
- Fullbright & Noclip utilities
    ]]
})

-- Основной цикл
RunService.RenderStepped:Connect(function(deltaTime)
    ESP.LastUpdate = ESP.LastUpdate + deltaTime
    if ESP.LastUpdate >= ESP.UpdateRate then
        UpdateESP()
        ESP.LastUpdate = 0
    end
    
    -- Проверяем наличие персонажа
    if not MyCharacter or not MyCharacter.Parent then
        MyCharacter = LocalPlayer.Character
        if MyCharacter then
            SetupCharacter()
        end
        return
    end
    
    -- Fullbright
    if Settings.fullbright then
        enableFullbright()
    end
    
    -- Noclip
    if Settings.Noclip and MyCharacter then
        for _, part in pairs(MyCharacter:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Очистка при выходе
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    ClearESP()
    if ESPConnection then
        ESPConnection:Disconnect()
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        ClearESP()
        if ESPConnection then
            ESPConnection:Disconnect()
        end
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
        end
    end
end)

-- Инициализация
SetupCharacter()
ToggleESP(ESP.Enabled)

-- Уведомление
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Version: " .. scrVer,
    Duration = 5,
    Image = 4483362458
})