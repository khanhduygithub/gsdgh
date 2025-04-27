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
	AimbotEnabled = false,
    fullbright = false,
    Noclip = false,
    AntiFall = false,
    AntiAFK = false,
    teleport = false,
        Enabled = false,
    FOV = 150,
    Smoothness = 0.65
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


local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(128, 0, 128)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.FOV
FOVCircle.Position = Camera.ViewportSize / 2

-- Variables
local ValidNPCs = {}
local RaycastParams = RaycastParams.new()
RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}

-- Functions

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
    -- Làm mới danh sách NPC
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
    local predictionTime = 0.02
    local predictedRoot = root.Position + velocity * predictionTime
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
    local smooth = 0.65
    local newLookVector = camCF.LookVector:Lerp(direction, smooth)
    Camera.CFrame = CFrame.new(camCF.Position, camCF.Position + newLookVector)
end

-- Main loop
local lastUpdate = 0
local UPDATE_RATE = 0.3

RunService.Heartbeat:Connect(function(dt)
    -- Update FOV Circle
    FOVCircle.Position = Camera.ViewportSize / 2
    FOVCircle.Radius = Settings.FOV * (Camera.ViewportSize.Y / 1080)
    FOVCircle.Visible = Settings.Enabled

    -- Update NPC list theo thời gian
    lastUpdate = lastUpdate + dt
    if lastUpdate >= UPDATE_RATE then
        updateNPCs()
        lastUpdate = 0
    end

    -- Nếu Aimbot đang bật
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

-- Auto Xóa nếu NPC chết
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

local Cooldown = 0.1
local TrackCount = 1
local BondCount = 0
local TrackPassed = false
local FoundLobby = false
local Running = false

local function AutoBond()
    if not Running then return end

    if game.PlaceId == 116495829188952 then
        local CreateParty = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("CreatePartyClient")
        local HRP = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

        while Running and task.wait(Cooldown) do
            if not FoundLobby then
                print("Finding Lobby...")
                for _,v in pairs(game:GetService("Workspace").TeleportZones:GetChildren()) do
                    if v.Name == "TeleportZone" and v.BillboardGui.StateLabel.Text == "Waiting for players..." then
                        print("Lobby Found!")
                        HRP.CFrame = v.ZoneContainer.CFrame
                        FoundLobby = true
                        task.wait(1)
                        CreateParty:FireServer({["maxPlayers"] = 1})
                    end
                end
            end
        end

    elseif game.PlaceId == 70876832253163 then
        local StartingTrack = game:GetService("Workspace").RailSegments:FindFirstChild("RailSegment")
        local CollectBond = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("ActivateObjectClient")
        local Items = game:GetService("Workspace").RuntimeItems
        local HRP = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

        HRP.Anchored = true

        while Running and task.wait(Cooldown) do
            if not TrackPassed then
                print("Teleporting to track", TrackCount)
                TrackPassed = true
            end

            HRP.CFrame = StartingTrack.Guide.CFrame + Vector3.new(0,250,0)

            if StartingTrack.NextTrack.Value ~= nil then
                StartingTrack = StartingTrack.NextTrack.Value
                TrackCount += 1
            else
                game:GetService("TeleportService"):Teleport(116495829188952, game:GetService("Players").LocalPlayer)
            end

            repeat
                for _,v in pairs(Items:GetChildren()) do
                    if v.Name == "Bond" or v.Name == "BondCalculated" then
                        spawn(function()
                            for _ = 1, 1000 do
                                pcall(function()
                                    v.Part.CFrame = HRP.CFrame
                                end)
                            end
                            CollectBond:FireServer(v)
                        end)

                        if v.Name == "Bond" then
                            BondCount += 1
                            print("Got", BondCount, "Bonds")
                            v.Name = "BondCalculated"
                        end
                    end
                end
                task.wait()
            until Items:FindFirstChild("Bond") == nil

            TrackPassed = false
        end
    end
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
AimbotTab:CreateSection("Main")
AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = Settings.Enabled,
    Callback = function(state)
        Settings.Enabled = state
    end
})
AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = Settings.FOV,
    Callback = function(v)
        Settings.FOV = v
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
UtilityTab:CreateSection("AutoBond")
UtilityTab:CreateToggle({
    Name = "AutoBond", 
    CurrentValue = Settings.autobond, 
    Callback = function(v)
        Settings.autobond = v
        Running = v
        if v then
            task.spawn(AutoBond)
        end
    end
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
local teleportLocations = {
    ["Train"] = CFrame.new(0, 50, 0), -- Toạ độ Train Station (bạn thay tọá đúng theo game)
    ["Sterling"] = CFrame.new(347, 87, -455),
    ["Tesla"] = CFrame.new(1200, 100, -600),
    ["Fort"] = CFrame.new(800, 120, -1200),
}

-- Tạo Button cho mỗi vị trí
for locationName, locationCFrame in pairs(teleportLocations) do
    TeleTab:CreateButton({
        Name = "Teleport to " .. locationName,
        Callback = function()
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = locationCFrame
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. locationName .. "!",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                warn("Không tìm thấy nhân vật hoặc HumanoidRootPart")
            end
        end
    })
end
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