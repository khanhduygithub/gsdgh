--// Bonds Farm V1.5

local Cooldown = 0.1

local TrackCount = 1
local BondCount = 0
local TrackPassed = false
local FoundLobby = false

if game.PlaceId == 116495829188952 then

    local CreateParty = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("CreatePartyClient")
    local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart

    while task.wait(Cooldown) do
        if FoundLobby == false then
            print("Finding Lobby...")
            for i,v in pairs(game:GetService("Workspace").TeleportZones:GetChildren()) do
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
    local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart

    HRP.Anchored = true

    while task.wait(Cooldown) do
    if TrackPassed == false then
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
        for i,v in pairs(Items:GetChildren()) do
            if v.Name == "Bond" or v.Name == "BondCalculated" then
                spawn(function()
                    for i = 1, 1000 do
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
