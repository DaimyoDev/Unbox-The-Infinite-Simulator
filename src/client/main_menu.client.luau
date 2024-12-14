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
local Client_Helpers = require(game.ReplicatedStorage.Shared.client_helpers)

local backup = Instance.new("ScreenGui")
backup.Parent = PlayerGui
backup.Name = "Backup"
backup.DisplayOrder = -5
local backupFrame = Instance.new("Frame")
backupFrame.Parent = backup
backupFrame.Size = UDim2.new(1, 0, 1.1, 0)
backupFrame.Position = UDim2.new(0, 0, -0.1, 0)
backupFrame.BackgroundColor3 = Color3.fromRGB(18, 121, 161)

Client_Helpers:loadMainMenu(React, PlayButtonClicked, root)