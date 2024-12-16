local basicEnemyModel = game.ServerStorage["Enemy Noob"]
local EnemyAIScript = game.ServerScriptService.Server.enemyai
local PlayButtonClicked = game.ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
local Helpers = require(game.ReplicatedStorage.Shared.helpers)

PlayButtonClicked.OnServerEvent:Connect(function(_lobby, lobby2)
    for _, player in lobby2.playersData do
        player:LoadCharacter()
        Helpers.setPlayerAppearance(player, player)
    end
end)
--get playbutton clicked, select a map, get all players in the lobby, get them all to spawn at the map spawn. Get the difficulty settings for the bots.
--[[
local newEnemy = basicEnemyModel:Clone()
newEnemy.Parent = game.Workspace
EnemyAIScript:Clone().Parent = newEnemy
]]

