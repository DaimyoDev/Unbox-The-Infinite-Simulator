local RespawnPlayer = game.ReplicatedStorage.Shared.Remote_Events.RespawnPlayer
local Helpers = require(script.Parent.helpers)

RespawnPlayer.OnServerEvent:Connect(function(player)
    task.wait(2)
    player:LoadCharacter()
    Helpers.setPlayerAppearance(player, player)
end)