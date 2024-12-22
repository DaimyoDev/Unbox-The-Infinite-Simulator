local TeleportService = game:GetService("TeleportService")
local GameFunctions = require(game.ReplicatedStorage.Shared.game_functions)
local Players = game:GetService("Players")
local enemies = game.ReplicatedStorage.Enemies
local enemyai = game.ServerScriptService.Server.enemyai
local EnemiesRemaining = game.ServerStorage.EnemiesRemaining
Players.CharacterAutoLoads = false
local TestRoundData = {
    waves = 5,
    difficulty = 1,
    lives = 3,
    startingEnemyCount = 5
}


Players.PlayerAdded:Connect(function(player)
    local teleportData = player:GetJoinData()
    print(teleportData)

    GameFunctions:setPlayerAppearance(player)

end)

local basicEnemyModel = game.ServerStorage.Enemies["Enemy Noob"]
local EnemyAIScript = game.ServerScriptService.Server.enemyai

local enemyCount = TestRoundData.startingEnemyCount
EnemiesRemaining.Value = enemyCount

local function wave()
    for count = enemyCount, 0, -1 do
        local newEnemy = basicEnemyModel:Clone()
        local newScript = EnemyAIScript:Clone()
        newScript.Parent = newEnemy
        newEnemy.Parent = game.Workspace
    end
end

local function prepareNextRound()

end