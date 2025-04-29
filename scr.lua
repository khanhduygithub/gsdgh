local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- GUI setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Button creation function
local function createButton(text, yPos, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, yPos)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Auto Bonds logic
local farming = false
createButton("Auto Bonds", 0, function(btn)
	farming = not farming
	btn.Text = farming and "Stop Auto Bonds" or "Auto Bonds"
	while farming do
		for _, bond in pairs(workspace:GetDescendants()) do
			if bond:IsA("Part") and bond.Name == "Bond" then
				char:WaitForChild("HumanoidRootPart").CFrame = bond.CFrame + Vector3.new(0, 5, 0)
				task.wait(0.15)
			end
		end
		task.wait(1)
	end
end)

-- Teleport locations
local locations = {
	["Station"] = Vector3.new(100, 10, 500),
	["Tunnel"] = Vector3.new(-200, 15, 400),
	["Bridge"] = Vector3.new(300, 25, -150)
}

local i = 1
for name, pos in pairs(locations) do
	createButton("TP: "..name, 40 * i, function()
		char:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos)
	end)
	i += 1
end
