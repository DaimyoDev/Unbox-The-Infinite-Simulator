local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Shared.Packages:FindFirstChild("react-roblox"))
local Players = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local PlayerGui = Players.PlayerGui
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
local handle = Instance.new("ScreenGui")
handle.IgnoreGuiInset = true
handle.Parent = PlayerGui
local root = ReactRoblox.createRoot(handle)
local MainMenu = require(ReplicatedStorage.Shared.UIComponents.MainMenu)
local PlayerLoaded = game.ReplicatedStorage.Shared.Remote_Events.PlayerLoaded

local function newMainMenu() 
    return React.createElement(MainMenu, {
        Root = root
    })
end

root:render(React.createElement(newMainMenu), {}, {})

PlayerLoaded.OnClientEvent:Connect(function()
    root:unmount()
end)
