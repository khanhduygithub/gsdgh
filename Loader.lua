-- Auto Bond Script for DeadRails
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm teleport tới 1 Part
local function teleportTo(part)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
    end
end

-- Hàm lấy tất cả bond trong Workspace
local function getAllBonds()
    local bonds = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:lower():find("bond") then
            table.insert(bonds, obj)
        end
    end
    return bonds
end

-- Vòng lặp AutoFarm
while task.wait(1) do
    local bonds = getAllBonds()
    for _, bond in ipairs(bonds) do
        teleportTo(bond)
        wait(0.5) -- Đợi lụm xong bond
    end
end
