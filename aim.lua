local KhanhDuyHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/khanhduygithub/gsdgh/refs/heads/main/UiRedz.lua"))()

local Window = KhanhDuyHub:CreateWindow({
    Name = "KhanhDuy Hub | DeadRails",
})

local MainTab = Window:CreateTab("Main", 0)

MainTab:CreateButton({
    Name = "AutoBond",
    Callback = function()
        print("AutoBond ON")
    end,
})
