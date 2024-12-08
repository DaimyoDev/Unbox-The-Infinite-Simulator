local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Shared.Packages:FindFirstChild("react-roblox"))
local Players = game:GetService("Players")

local function MyTestFrame() 
	return React.createElement("Frame", {
		Size = UDim2.new(0,100,0,100),
	})
end

local handle = Instance.new("ScreenGui")
handle.Parent = Players.LocalPlayer.PlayerGui
local root = ReactRoblox.createRoot(handle)
root:render(React.createElement(MyTestFrame, {}, {}))
