local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayButtonClicked = ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
Players.CharacterAutoLoads = false

PlayButtonClicked.OnServerEvent:Connect(function(player)
    player:LoadCharacter()
end)