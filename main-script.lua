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
local Aiming = false
local Shooting = false
local LockedTarget = nil
local MousePos = Vector2.new()
local LastMousePos = Vector2.new()
local FOV_Circle
local NPCList = {}
local CharacterAddedConnection = nil


-- Настройки
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
    UpdateRate = 0.05, -- Уменьшено время обновления
    IgnoreDead = true,
    LastUpdate = 0
}

-- Настройки
local Settings = {
    Enabled = false,
    AutoAim = true,
    ManualAim = false, 
    AimFOV = 120,
    MaxDistance = 500,
    Smoothing = 0.6,
    PriorityPart = "Head",
    Use3DDistance = true,
    IgnorePlayers = true,
    TeamCheck = false,
    WallCheck = false,
    AutoShoot = false,
    ShowFOV = true,
    FOVVisible = true,
    FOVFilled = false,
    fullbright = false,
    FOVThickness = 2,
    FOVColor = Color3.fromRGB(255, 255, 255),
    AimKey = Enum.KeyCode.E,
    ShootKey = Enum.KeyCode.F,
    RefreshRate = 0.1,
    Noclip = false,
    AntiFall = false,
    AntiAFK = false,
}

-- Табы
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local FullbrightTab = Window:CreateTab("Fullbright", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)
local ChangelogsTab = Window:CreateTab("Changelogs", 4483362458)

-- Функция для обработки смерти/возрождения персонажа
local function SetupCharacter()
    if MyCharacter then
        local humanoid = MyCharacter:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                Aiming = false
                LockedTarget = nil
                Shooting = false
                
                MyCharacter = LocalPlayer.CharacterAdded:Wait()
                task.wait(0.5)
                InitializeFOV()
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
    
    -- Учитываем только HumanoidRootPart для производительности
    return Vector3.new(size.X * 2, size.Y * 3, size.Z * 2) -- Увеличенные размеры для лучшей видимости
end

local function CreateESP(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Box ESP
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = ESP.Color
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    box.ZIndex = 1
    
    -- Highlight ESP
    local highlight = Instance.new("Highlight")
    highlight.Parent = CoreGui
    highlight.Adornee = character
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = ESP.Color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = ESP.Color
    highlight.OutlineTransparency = 0
    
    -- HP Bar
    local hpBar = Drawing.new("Line")
    hpBar.Visible = false
    hpBar.Color = Color3.fromRGB(0, 255, 0)
    hpBar.Thickness = 2
    hpBar.ZIndex = 2
    
    -- HP Text
    local hpText = Drawing.new("Text")
    hpText.Visible = false
    hpText.Color = Color3.fromRGB(255, 255, 255)
    hpText.Size = 13
    hpText.Center = true
    hpText.Outline = true
    hpText.ZIndex = 3
    
    -- Name Text
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Size = 14
    nameText.Center = true
    nameText.Outline = true
    nameText.ZIndex = 3
    
    -- Distance Text
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
            
            -- Проверка на мертвых NPC
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
                -- Calculate character size
                local size = CalculateCharacterSize(character)
                local scale = 1000 / position.Z
                local width = math.max(20, size.X * scale)
                local height = math.max(30, size.Y * scale)
                
                -- Update box
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(position.X - width/2, position.Y - height/2)
                box.Visible = ESP.Mode == "Boxes"
                box.Color = ESP.Color
                
                -- Update highlight
                local highlight = ESP.Highlights[character]
                if highlight then
                    highlight.Enabled = ESP.Mode == "Highlight"
                    highlight.Adornee = character
                    highlight.FillColor = ESP.Color
                    highlight.OutlineColor = ESP.Color
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                end
                
                -- Get texts
                local texts = ESP.Texts[character]
                if texts then
                    -- HP Bar
                    if ESP.ShowHP and humanoid then
                        local hpPercent = humanoid.Health / humanoid.MaxHealth
                        local barLength = width * hpPercent
                        
                        if ESP.HPPosition == "Horizontal" then
                            texts.hpBar.From = Vector2.new(position.X - width/2, position.Y - height/2 - 10)
                            texts.hpBar.To = Vector2.new(position.X - width/2 + barLength, position.Y - height/2 - 10)
                        else -- Vertical
                            texts.hpBar.From = Vector2.new(position.X - width/2 - 10, position.Y + height/2)
                            texts.hpBar.To = Vector2.new(position.X - width/2 - 10, position.Y + height/2 - height * hpPercent)
                        end
                        
                        texts.hpBar.Color = Color3.fromHSV(hpPercent * 0.3, 1, 1)
                        texts.hpBar.Visible = true
                    else
                        texts.hpBar.Visible = false
                    end
                    
                    -- HP Text
                    if ESP.ShowHPText and humanoid then
                        texts.hpText.Text = string.format("%d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                        texts.hpText.Position = Vector2.new(position.X, position.Y - height/2 - 25)
                        texts.hpText.Visible = true
                    else
                        texts.hpText.Visible = false
                    end
                    
                    -- Name Text
                    if ESP.ShowName then
                        texts.nameText.Text = character.Name
                        texts.nameText.Position = Vector2.new(position.X, position.Y + height/2 + 5)
                        texts.nameText.Visible = true
                    else
                        texts.nameText.Visible = false
                    end
                    
                    -- Distance Text
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
            -- Cleanup if character no longer exists
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
        -- Create ESP for existing NPCs
        for _, model in ipairs(Workspace:GetChildren()) do
            if model:IsA("Model") and model ~= MyCharacter and model:FindFirstChildOfClass("Humanoid") then
                CreateESP(model)
            end
        end
        
        -- Подключаем отслеживание новых NPC
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

-- Замените функцию SetFastProximityPrompt на эту новую версию
local function SetFastProximityPrompt(enabled)
    FastProximityPromptEnabled = enabled
    
    -- Очищаем предыдущие соединения
    for _, connection in pairs(ProximityPromptConnections) do
        connection:Disconnect()
    end
    ProximityPromptConnections = {}
    
    if enabled then
        -- Обрабатываем существующие промпты
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end
        end
        
        -- Создаем соединение для новых промптов
        table.insert(ProximityPromptConnections, workspace.DescendantAdded:Connect(function(descendant)
            if FastProximityPromptEnabled and descendant:IsA("ProximityPrompt") then
                descendant.HoldDuration = 0
            end
        end))
    end
end

-- Инициализация FOV круга
local function InitializeFOV()
    if FOV_Circle then FOV_Circle:Remove() end
    FOV_Circle = Drawing.new("Circle")
    FOV_Circle.Transparency = 1
    FOV_Circle.Color = Settings.FOVColor
    FOV_Circle.Thickness = Settings.FOVThickness
    FOV_Circle.Filled = Settings.FOVFilled
    FOV_Circle.Visible = Settings.FOVVisible
    FOV_Circle.Radius = Settings.AimFOV
end

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

-- UI элементы
AimbotTab:CreateSection("Main")
AimbotTab:CreateToggle({
    Name = "Enable Aimbot", 
    CurrentValue = Settings.Enabled, 
    Callback = function(v) 
        Settings.Enabled = v 
        if not v then 
            Aiming = false
            LockedTarget = nil
        end
    end
})

AimbotTab:CreateToggle({
    Name = "Auto Aim NPC", 
    CurrentValue = Settings.AutoAim, 
    Callback = function(v) 
        Settings.AutoAim = v 
        if not v and not Settings.ManualAim then
            LockedTarget = nil
            Aiming = false
        end
    end
})

AimbotTab:CreateToggle({
    Name = "Manual Aim Mode",
    CurrentValue = Settings.ManualAim,
    Callback = function(v)
        Settings.ManualAim = v
        if not v then
            Aiming = false
            LockedTarget = nil
        end
    end
})

AimbotTab:CreateToggle({
    Name = "Auto Shoot", 
    CurrentValue = Settings.AutoShoot, 
    Callback = function(v) 
        Settings.AutoShoot = v 
    end
})

AimbotTab:CreateSection("Targeting")
AimbotTab:CreateSlider({
    Name = "Aim FOV", 
    Range = {50, 500}, 
    Increment = 5, 
    CurrentValue = Settings.AimFOV, 
    Callback = function(v) 
        Settings.AimFOV = v 
        if FOV_Circle then
            FOV_Circle.Radius = v
        end
    end
})

AimbotTab:CreateSlider({
    Name = "Max Distance", 
    Range = {100, 2000}, 
    Increment = 50, 
    CurrentValue = Settings.MaxDistance, 
    Callback = function(v) 
        Settings.MaxDistance = v 
    end
})

AimbotTab:CreateDropdown({
    Name = "Priority Part", 
    Options = {"Head", "HumanoidRootPart", "UpperTorso"}, 
    CurrentOption = Settings.PriorityPart, 
    Callback = function(v) 
        Settings.PriorityPart = v 
    end
})

AimbotTab:CreateSlider({
    Name = "Speed", 
    Range = {0.1, 1}, 
    Increment = 0.05, 
    CurrentValue = Settings.Smoothing, 
    Callback = function(v) 
        Settings.Smoothing = v 
    end
})

AimbotTab:CreateToggle({
    Name = "Ignore Players", 
    CurrentValue = Settings.IgnorePlayers, 
    Callback = function(v) 
        Settings.IgnorePlayers = v 
    end
})

AimbotTab:CreateSection("FOV Circle")
AimbotTab:CreateToggle({
    Name = "Show FOV", 
    CurrentValue = Settings.ShowFOV, 
    Callback = function(v) 
        Settings.ShowFOV = v 
        if FOV_Circle then
            FOV_Circle.Visible = v and Settings.FOVVisible
        end
    end
})

AimbotTab:CreateToggle({
    Name = "FOV Filled", 
    CurrentValue = Settings.FOVFilled, 
    Callback = function(v) 
        Settings.FOVFilled = v 
        if FOV_Circle then
            FOV_Circle.Filled = v
        end
    end
})

AimbotTab:CreateSlider({
    Name = "FOV Thickness", 
    Range = {1, 10}, 
    Increment = 1, 
    CurrentValue = Settings.FOVThickness, 
    Callback = function(v) 
        Settings.FOVThickness = v 
        if FOV_Circle then
            FOV_Circle.Thickness = v
        end
    end
})

AimbotTab:CreateColorPicker({
    Name = "FOV Color", 
    Color = Settings.FOVColor, 
    Callback = function(c) 
        Settings.FOVColor = c 
        if FOV_Circle then
            FOV_Circle.Color = c
        end
    end
})

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

-- Проверка валидности цели
local function IsValidTarget(model)
    if not model or not model:IsA("Model") or model == MyCharacter then return false end

    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return false end

    local player = Players:GetPlayerFromCharacter(model)
    if Settings.IgnorePlayers and player then return false end

    return true
end

local function GetTargetPart(model)
    if not model or not model:IsA("Model") then return nil end

    local part = model:FindFirstChild(Settings.PriorityPart)
    if part and part:IsA("BasePart") then return part end

    local head = model:FindFirstChild("Head") or model:FindFirstChild("head")
    if head and head:IsA("BasePart") then return head end

    local torso = model:FindFirstChild("HumanoidRootPart") or 
                 model:FindFirstChild("UpperTorso") or 
                 model:FindFirstChild("Torso")
    if torso and torso:IsA("BasePart") then return torso end

    return nil
end

-- Обновление списка NPC
local function UpdateNPCList()
    NPCList = {}
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model ~= MyCharacter then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(NPCList, model)
            end
        end
    end
end

-- Автоматическое наведение на ближайшего NPC
local function AutoAimAtNearestNPC()
    if not Settings.Enabled or not MyCharacter then return end
    
    local myPos = MyCharacter:GetPivot().Position
    local bestTarget, closestDist = nil, Settings.AimFOV + 1
    
    for _, model in ipairs(NPCList) do
        if not IsValidTarget(model) then continue end
        
        local part = GetTargetPart(model)
        if not part then continue end
        
        local dist3D = (part.Position - myPos).Magnitude
        if Settings.Use3DDistance and dist3D > Settings.MaxDistance then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end
        
        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - MousePos).Magnitude
        if dist2D > Settings.AimFOV then continue end
        
        if dist2D < closestDist then
            closestDist = dist2D
            bestTarget = part
        end
    end
    
    if bestTarget then
        LockedTarget = bestTarget
        if not Settings.ManualAim then
            Aiming = true
        end
    elseif not Settings.ManualAim then
        LockedTarget = nil
        Aiming = false
    end
end

-- Периодическое обновление списка NPC
task.spawn(function()
    while true do
        UpdateNPCList()
        task.wait(3)
    end
end)

-- Основной цикл
RunService.RenderStepped:Connect(function(deltaTime)
    -- Обновляем позицию мыши
    LastMousePos = MousePos
    MousePos = UserInputService:GetMouseLocation()

    ESP.LastUpdate = ESP.LastUpdate + deltaTime
    if ESP.LastUpdate >= ESP.UpdateRate then
        UpdateESP()
        ESP.LastUpdate = 0
    end
    

    -- Обновляем FOV круг
    if FOV_Circle then
        FOV_Circle.Position = MousePos
        FOV_Circle.Visible = Settings.ShowFOV and Settings.FOVVisible
    end
    
    -- Проверяем наличие персонажа
    if not MyCharacter or not MyCharacter.Parent then
        MyCharacter = LocalPlayer.Character
        if MyCharacter then
            SetupCharacter()
        end
        return
    end
    
    -- Автоматическое прицеливание (только если не в ручном режиме)
    if Settings.Enabled and Settings.AutoAim and not Settings.ManualAim then
        AutoAimAtNearestNPC()
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
    
    -- Применение прицеливания
    if Settings.Enabled and (Aiming or (Settings.AutoAim and not Settings.ManualAim)) and LockedTarget and LockedTarget.Parent then
        local camPos = Camera.CFrame.Position
        local direction = (LockedTarget.Position - camPos).Unit
        local smoothDirection = Camera.CFrame.LookVector:Lerp(direction, Settings.Smoothing)
        
        Camera.CFrame = CFrame.lookAt(camPos, camPos + smoothDirection)
        
        -- Автоматическая стрельба
        if Settings.AutoShoot and Shooting then
            mouse1press()
            task.wait(0.03)
            mouse1release()
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

-- Обработка клавиш
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Ручное прицеливание по клавише
    if input.KeyCode == Settings.AimKey then
        if Settings.Enabled and Settings.ManualAim then
            if not Aiming then
                -- Включаем ручное прицеливание
                Aiming = true
                AutoAimAtNearestNPC()  -- Попытаемся найти цель
                Rayfield:Notify({
                    Title = "Aimbot",
                    Content = LockedTarget and "Manual Aim: Target Locked" or "Manual Aim: No Target Found",
                    Duration = 2,
                    Image = 4483362458
                })
            else
                -- Выключаем ручное прицеливание
                Aiming = false
                LockedTarget = nil
                Rayfield:Notify({
                    Title = "Aimbot",
                    Content = "Manual Aim Disabled",
                    Duration = 2,
                    Image = 4483362458
                })
            end
        elseif Settings.Enabled and not Settings.ManualAim then
            Rayfield:Notify({
                Title = "Aimbot",
                Content = "Manual mode is disabled in settings",
                Duration = 2,
                Image = 4483362458
            })
        end
    end

    -- Переключение автострельбы
    if input.KeyCode == Settings.ShootKey then
        Shooting = not Shooting
        Rayfield:Notify({
            Title = "AutoShoot",
            Content = Shooting and "Enabled" or "Disabled",
            Duration = 2,
            Image = 4483362458
        })
    end
end)

-- Инициализация
InitializeFOV()
SetupCharacter()
UpdateNPCList()ToggleESP(ESP.Enabled) -- Инициализируем ESP с текущими настройками


-- Уведомление
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Version: " .. scrVer,
    Duration = 5,
    Image = 4483362458
})
