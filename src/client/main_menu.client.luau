local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Shared.Packages:FindFirstChild("react-roblox"))
local Players = game:GetService("Players").LocalPlayer
local PlayButtonClicked = ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
local StarterGui = game:GetService("StarterGui")
local PlayerGui = Players.PlayerGui
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local function MyTestFrame() 
	return React.createElement("Frame", {
		Size = UDim2.new(1,0,1.1,0),
		Position = UDim2.new(0, 0, -0.1, 0),
		BackgroundColor3 = Color3.fromRGB(18, 121, 161)
	}, {
		React.createElement("TextButton", {
			Size = UDim2.new(0.2,0,0.2,0),
			Position = UDim2.new(0.4, 0, 0.4, 0),
			TextSize = 28,
			Text = "Play Game",
			[React.Event.Activated] = function()
				PlayButtonClicked:FireServer()
				PlayerGui.ScreenGui.Enabled = false
			end
		})
	})
end

local handle = Instance.new("ScreenGui")
handle.Parent = PlayerGui
local root = ReactRoblox.createRoot(handle)
root:render(React.createElement(MyTestFrame, {}, {}))
