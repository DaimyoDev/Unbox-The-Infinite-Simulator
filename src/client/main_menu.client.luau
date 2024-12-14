local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Shared.Packages:FindFirstChild("react-roblox"))
local Players = game:GetService("Players").LocalPlayer
local PlayButtonClicked = ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
local StarterGui = game:GetService("StarterGui")
local PlayerGui = Players.PlayerGui
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
local handle = Instance.new("ScreenGui")
handle.Parent = PlayerGui
local root = ReactRoblox.createRoot(handle)

local function MyTestFrame() 
	return React.createElement("Frame", {
		Size = UDim2.new(1,0,1.1,0),
		Position = UDim2.new(0, 0, -0.1, 0),
		BackgroundColor3 = Color3.fromRGB(18, 121, 161)
	}, {
		React.createElement("TextButton", {
			Size = UDim2.new(0.2,0,0.1,0),
			Position = UDim2.new(0.4, 0, 0.4, 0),
			TextSize = 35,
			Text = "Play Game",
			TextColor3 = Color3.new(0, 0, 0),
			FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
			[React.Event.Activated] = function()
				PlayButtonClicked:FireServer()
				root:unmount("Frame")
			end
		}, React.createElement("UICorner", {
			CornerRadius = UDim.new(0.2, 0)
		}), React.createElement("UIGradient", {
			Color = ColorSequence.new(Color3.new(0.9, 0.9, 0.9), Color3.new(0.5, 0.5, 0.5)),
			Rotation = 45
		}))
	}, {
		React.createElement("TextButton", {
			Size = UDim2.new(0.2,0,0.1,0),
			Position = UDim2.new(0.4, 0, 0.53, 0),
			TextSize = 35,
			Text = "Daily Quests",
			TextColor3 = Color3.new(0, 0, 0),
			FontFace = Font.fromEnum(Enum.Font.SourceSansBold)
		}, React.createElement("UICorner", {
			CornerRadius = UDim.new(0.2, 0)
		}), React.createElement("UIGradient", {
			Color = ColorSequence.new(Color3.new(0.9, 0.9, 0.9), Color3.new(0.5, 0.5, 0.5)),
			Rotation = 45
		}))
	})
end

root:render(React.createElement(MyTestFrame, {}, {}))