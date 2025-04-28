-- Tải thư viện Rayfield chính chủ
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo Window chính
local Window = Rayfield:CreateWindow({
   Name = "KiciaHub - DeadRails",
   LoadingTitle = "KiciaHub Loading...",
   LoadingSubtitle = "by bạn và ChatGPT",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- lưu setting (tùy chọn)
      FileName = "KiciaHubConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "", -- nếu muốn invite discord
      RememberJoins = true
   },
   KeySystem = false, -- không cần key
})

-- Tab Main
local MainTab = Window:CreateTab("Main", 4483362458) -- icon random
local AutoBondToggle = MainTab:CreateToggle({
   Name = "AutoBond",
   CurrentValue = false,
   Flag = "AutoBond",
   Callback = function(Value)
      if Value then
         print("AutoBond Enabled")
      else
         print("AutoBond Disabled")
      end
   end,
})

local FullbrightToggle = MainTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
      if Value then
         print("Fullbright Enabled")
      else
         print("Fullbright Disabled")
      end
   end,
})

local NoclipToggle = MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      if Value then
         print("Noclip Enabled")
      else
         print("Noclip Disabled")
      end
   end,
})

-- Tab Aim
local AimTab = Window:CreateTab("Aim", 4483362458)
local AimbotToggle = AimTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value)
      if Value then
         print("Aimbot Enabled")
      else
         print("Aimbot Disabled")
      end
   end,
})

local FOVSlider = AimTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {10, 500},
   Increment = 5,
   Suffix = "FOV",
   CurrentValue = 50,
   Flag = "FOV",
   Callback = function(Value)
      print("FOV set to", Value)
   end,
})

-- Tab ESP
local ESPTab = Window:CreateTab("ESP", 4483362458)
local ESPToggle = ESPTab:CreateToggle({
   Name = "ESP Enabled",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
      if Value then
         print("ESP Enabled")
      else
         print("ESP Disabled")
      end
   end,
})

-- Tab Teleport
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local TrainButton = TeleportTab:CreateButton({
   Name = "Teleport to Train",
   Callback = function()
      print("Teleporting to Train")
   end,
})

local TeslaButton = TeleportTab:CreateButton({
   Name = "Teleport to Tesla",
   Callback = function()
      print("Teleporting to Tesla")
   end,
})

local FortButton = TeleportTab:CreateButton({
   Name = "Teleport to Fort",
   Callback = function()
      print("Teleporting to Fort")
   end,
})

local SterlingButton = TeleportTab:CreateButton({
   Name = "Teleport to Sterling",
   Callback = function()
      print("Teleporting to Sterling")
   end,
})

local EndButton = TeleportTab:CreateButton({
   Name = "Teleport to End",
   Callback = function()
      print("Teleporting to End")
   end,
})

-- Nút đóng/mở menu
Rayfield:LoadConfiguration()
