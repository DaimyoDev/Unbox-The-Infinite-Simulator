local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Shared.Packages:FindFirstChild("react-roblox"))
local Players = game:GetService("Players").LocalPlayer
local PlayButtonClicked = ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
local StarterGui = game:GetService("StarterGui")
local PlayerGui = Players.PlayerGui
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
local handle = Instance.new("ScreenGui")
handle.IgnoreGuiInset = true
handle.Parent = PlayerGui
local root = ReactRoblox.createRoot(handle)
local Client_Helpers = require(game.ReplicatedStorage.Shared.client_helpers)

Client_Helpers:loadMainMenu(React, PlayButtonClicked, root)