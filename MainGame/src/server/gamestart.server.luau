local TeleportService = game:GetService("TeleportService")
local GameFunctions = require(game.ReplicatedStorage.Shared.game_functions)
local Players = game:GetService("Players")
Players.CharacterAutoLoads = false

Players.PlayerAdded:Connect(function(player)
    local teleportData = player:GetJoinData()
    print(teleportData)

    GameFunctions:setPlayerAppearance(player)

end)

local basicEnemyModel = game.ServerStorage["Enemy Noob"]
local EnemyAIScript = game.ServerScriptService.Server.enemyai

local newEnemy = basicEnemyModel:Clone()
local newScript = EnemyAIScript:Clone()
newScript.Parent = newEnemy
newEnemy.Parent = game.Workspace