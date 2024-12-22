local RespawnPlayer = game.ReplicatedStorage.Shared.Remote_Events.RespawnPlayer
local GameFunctions = require(game.ReplicatedStorage.Shared.game_functions)

RespawnPlayer.OnServerEvent:Connect(function(player)
    task.wait(2)
    player:LoadCharacter()
    GameFunctions.setPlayerAppearance(player, player)
end)