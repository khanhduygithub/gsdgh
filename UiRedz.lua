-- KhanhDuyHub Library
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local KhanhDuyHub = {}
local Windows = {}

local function MakeDraggable(Handle, Object)
	local Dragging, DragInput, MousePos, FramePos

	Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			MousePos = Input.Position
			FramePos = Object.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	Handle.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
			Object.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
		end
	end)
end

function KhanhDuyHub:CreateWindow(Settings)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "KhanhDuyHubGui"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 450, 0, 300)
	MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	MakeDraggable(MainFrame, MainFrame)

	local UICorner = Instance.new("UICorner", MainFrame)
	UICorner.CornerRadius = UDim.new(0, 8)

	local Title = Instance.new("TextLabel")
	Title.Text = Settings.Name or "KhanhDuy Hub"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.Parent = MainFrame

	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Text = "KhanhDuy"
	ToggleButton.Font = Enum.Font.Gotham
	ToggleButton.TextSize = 16
	ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleButton.Size = UDim2.new(0, 100, 0, 30)
	ToggleButton.Position = UDim2.new(1, -110, 0, 10)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ToggleButton.Parent = MainFrame

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = UDim2.new(1, 0, 1, -40)
	ContentFrame.Position = UDim2.new(0, 0, 0, 40)
	ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	ContentFrame.BorderSizePixel = 0
	ContentFrame.Parent = MainFrame

	UICorner:Clone().Parent = ContentFrame

	ToggleButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	return {
		CreateTab = function(_, TabName, TabIcon)
			local Tab = Instance.new("Frame")
			Tab.Size = UDim2.new(1, 0, 1, 0)
			Tab.BackgroundTransparency = 1
			Tab.Parent = ContentFrame

			local TabLabel = Instance.new("TextLabel")
			TabLabel.Text = TabName
			TabLabel.Font = Enum.Font.Gotham
			TabLabel.TextSize = 20
			TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabLabel.BackgroundTransparency = 1
			TabLabel.Size = UDim2.new(1, 0, 0, 40)
			TabLabel.Parent = Tab

			return {
				CreateButton = function(_, Settings)
					local Button = Instance.new("TextButton")
					Button.Text = Settings.Name or "Button"
					Button.Size = UDim2.new(1, -20, 0, 30)
					Button.Position = UDim2.new(0, 10, 0, 50)
					Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					Button.TextColor3 = Color3.fromRGB(255, 255, 255)
					Button.Font = Enum.Font.Gotham
					Button.TextSize = 16
					Button.Parent = Tab
					Button.MouseButton1Click:Connect(function()
						Settings.Callback()
					end)
				end,
			}
		end,
	}
end

return KhanhDuyHub
