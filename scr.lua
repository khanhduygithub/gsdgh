local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({
   Name = "executorx script",
   Icon = 0, 
   LoadingTitle = "🚨 Loading, please wait for the script to load🚨",
   LoadingSubtitle = "🎆 by Justyn 🎆",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "simple function by ExecutorX"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = false
   },

   KeySystem = true,
   KeySettings = {
      Title = "executorx key system",
      Subtitle = "Key system by Justyn",
      Note = "limited key:executorX123, btw all in lowercaps except for the X its a caps",
      FileName = "nil",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"executorX123"}
   }
})

local Tab = Window:CreateTab("script that made by ExecutorX", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Esp script",
   Callback = function()
          loadstring(game:HttpGet('https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "aimbot script",
   Callback = function()
          loadstring(game:HttpGet('https://raw.githubusercontent.com/nahnahanah/nahnahanah/main/Aimbot%20script'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Chat Spammer",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/nahnahanah/nahnahanah/refs/heads/main/Chat%20spammer"))()
   end,
})

local loopTP = false
local targetPlayer = ""

local TPToggle = Tab:CreateToggle({
    Name = "Auto Loop Teleport",
    CurrentValue = false,
    Flag = "TPToggle",
    Callback = function(Value)
        loopTP = Value
        while loopTP do
            local player = game.Players:FindFirstChild(targetPlayer)
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
            end
            wait(0.5)
        end
    end
})

local TPInput = Tab:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player username",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        targetPlayer = Text
    end
})


local NoclipEnabled = false
local function NoclipFunction()
   while NoclipEnabled do
      for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
         if v:IsA("BasePart") then
            v.CanCollide = false
         end
      end
      RunService.Stepped:Wait()
   end
end

local NoclipToggle = Tab:CreateToggle({
   Name = "Noclip (Walk Through Walls)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(State)
      NoclipEnabled = State
      if State then
         Rayfield:Notify({ Title = "Noclip Enabled", Content = "You can now walk through walls!", Duration = 3 })
         task.spawn(NoclipFunction)
      else
         Rayfield:Notify({ Title = "Noclip Disabled", Content = "You can no longer walk through walls.", Duration = 3 })
      end
   end
})

local SpeedEnabled = false
local DefaultSpeed = 16
local SpeedBoost = DefaultSpeed

local function SpeedBoostFunction()
    while SpeedEnabled do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedBoost
        end
        task.wait(0.1)
    end
end

local Slider = Tab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 200},
   Increment = 2,
   Suffix = "Speed",
   CurrentValue = DefaultSpeed,
   Flag = "SpeedSlider",
   Callback = function(Value)
       SpeedBoost = Value
       if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = SpeedBoost
       end
   end
})

local Toggle = Tab:CreateToggle({
   Name = "Enable Speed Boost",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(State)
       SpeedEnabled = State
       if State then
           Rayfield:Notify({ Title = "Speed Boost Enabled", Content = "You can now use WalkSpeed.", Duration = 6.5 })
           task.spawn(SpeedBoostFunction)
       else
           Rayfield:Notify({ Title = "Speed Boost Disabled", Content = "You can no longer use WalkSpeed.", Duration = 6.5 })
           if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
               LocalPlayer.Character.Humanoid.WalkSpeed = DefaultSpeed
           end
       end
   end
})

local function TeleportToPlayer(targetName)
    local targetPlayer = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(targetName) or string.lower(player.DisplayName) == string.lower(targetName) then
            targetPlayer = player
            break
        end
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

            local shortDisplay = targetPlayer.DisplayName
            if #shortDisplay > 10 then
                shortDisplay = string.sub(shortDisplay, 1, 10) .. "..."
            end

            Rayfield:Notify({ Title = "Teleport Successful", Content = "You teleported to " .. shortDisplay .. " (" .. targetPlayer.Name .. ")", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Teleport Failed", Content = "Your character is not loaded!", Duration = 3 })
        end
    else
        Rayfield:Notify({ Title = "Teleport Failed", Content = "Player not found or not fully loaded!", Duration = 3 })
    end
end

local Input = Tab:CreateInput({
    Name = "Enter Player Name",
    PlaceholderText = "Type a player's name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(PlayerName)
        TeleportToPlayer(PlayerName)
    end
})

local Button = Tab:CreateButton({
   Name = "️Anti-Lag",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
               v:Destroy()
           end
       end
       for _, v in pairs(game.Lighting:GetChildren()) do
           if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
               v:Destroy()
           end
       end
       game.Lighting.GlobalShadows = false
       game.Lighting.FogEnd = 999999
       game.Lighting.Brightness = 2
       setfpscap(60) -- Optional FPS cap
       Rayfield:Notify({
           Title = "Anti-Lag Activated!",
           Content = "Lag has been reduced significantly.",
           Duration = 10
       })
   end
})

local Tab = Window:CreateTab("Blue lock rivals", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "toraisme",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/BlueLock"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "tbao hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/game/refs/heads/main/TbaoHubBlueLockRivals"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Arbix Hub",
   Callback = function()
          loadstring(game:HttpGet(('https://pastefy.app/lbLVUm8Z/raw'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "idk the name",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/selciawashere/screepts/refs/heads/main/BLRTBDMOBILEKEYSYS",true))()
   end,
})

local Tab = Window:CreateTab("brookhaven scripts", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "ExecutorX copying avatar",
   Callback = function()
          loadstring(game:HttpGet("https://pastebin.com/raw/5eLtfv9J"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Chaos Hub",
   Callback = function()
          loadstring(game:HttpGet("https://pastebin.com/raw/58jNvV3h"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Sander Hub",
   Callback = function()
          loadstring(game:HttpGet('https://raw.githubusercontent.com/kigredns/SanderXV4.2.2/refs/heads/main/NormalSS.lua'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Y-Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/Luarmor123/community-Y-HUB/refs/heads/main/YHUB%20ENGLISH"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "SP Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/as6cd0/SP_Hub/refs/heads/main/Brookhaven"))()
   end,
})

local Tab = Window:CreateTab("natural disaster survival script", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Super Rings by Lukas",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/Lukashub-coder/super-ring/refs/heads/main/Super%20ring!!"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "My Fly GUI",
   Callback = function()
          loadstring(game:HttpGet("https://pastebin.com/raw/xPJ8sHa1"))()
   end,
})

local Tab = Window:CreateTab("universal script", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
          loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "My Fly GUI",
   Callback = function()
          loadstring(game:HttpGet("https://pastebin.com/raw/xPJ8sHa1"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "AimLock",
   Callback = function()
          loadstring(game:HttpGet("https://pastebin.com/raw/frSeaLsT"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "NameLess Admin",
   Callback = function()
          loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
   end,
})

local Tab = Window:CreateTab("blox fruit scripts (NOT MINE!)", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Speed x hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Cokka hub",
   Callback = function()
          loadstring(game:HttpGet"https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua")()
   end,
})

local Button = Tab:CreateButton({
   Name = "Redz hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))()
   end,
})

local Tab = Window:CreateTab("dead rails script", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "SpiderX Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/SpiderScriptRB/Dead-Rails-SpiderXHub-Script/refs/heads/main/SpiderXHub%202.0.txt"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "gumanba Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails", true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Speed X Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Emplic Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/Emplic/deathrails/refs/heads/main/bond"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Sypher Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/deprivationist/Sypher-Hub/refs/heads/main/Dead%20Rails%20Sypher%20Hub.txt", true))()
   end,
})

local Tab = Window:CreateTab("Mm2 scripts", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Nexus Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-a-b/nexus/main/loadstring"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Mm2 script",
   Callback = function()
          loadstring(game:HttpGet"https://pastebin.com/raw/dB3kQmYm")()
   end,
})

local Button = Tab:CreateButton({
   Name = "Vertex",
   Callback = function()
          loadstring(game:HttpGet('https://raw.githubusercontent.com/vertex-peak/vertex/refs/heads/main/loadstring'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Mm2 script",
   Callback = function()
          loadstring(game:HttpGet('https://pastebin.com/raw/e89Mn4Ec'))()
   end,
})

local Tab = Window:CreateTab("Fisch script", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Banana Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Speed X hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "YHUB",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/Luarmor123/community-Y-HUB/refs/heads/main/Fisch-YHUB"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Solix Hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Raito hub",
   Callback = function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/Efe0626/RaitoHub/refs/heads/main/Script"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Fisch Script",
   Callback = function()
          loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2529a5f9dfddd5523ca4e22f21cceffa.lua"))()
   end,
})

local Tab = Window:CreateTab("use this if the gui is bugged", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Destroy GUI",
   Callback = function()
      if Rayfield then
         -- Attempt to destroy the Rayfield window
         local success, errorMessage = pcall(function()
            Rayfield:Destroy()  -- Destroy the entire Rayfield window (GUI)
         end)

         if success then
            print("Rayfield GUI destroyed successfully")
         else
            print("Error destroying Rayfield GUI: " .. errorMessage)
         end
      end
   end
})

local Button = Tab:CreateButton({
   Name = "Reexecute Script",
   Callback = function()
      print("Reexecuting the script...")

      -- Ensure executeScript exists and is a function before calling it
      if executeScript and type(executeScript) == "function" then
         local success, err = pcall(executeScript)
         if not success then
            warn("Error reexecuting script: " .. err)
         end
      else
         warn("executeScript function not found!")
      end
   end
})
