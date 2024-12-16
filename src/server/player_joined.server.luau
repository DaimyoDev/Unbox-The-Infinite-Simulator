local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayButtonClicked = ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
local PlayerLoaded = ReplicatedStorage.Shared.Remote_Events.PlayerLoaded
local Helpers = require(script.Parent.helpers)
Players.CharacterAutoLoads = false

--move to round system code.
PlayButtonClicked.OnServerEvent:Connect(function(player)
    PlayerLoaded:FireClient(player)
    Helpers.setPlayerAppearance(player, player)
end)

