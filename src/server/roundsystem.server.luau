local basicEnemyModel = game.ServerStorage["Enemy Noob"]
local EnemyAIScript = game.ServerScriptService.Server.enemyai

task.wait(20)

local newEnemy = basicEnemyModel:Clone()
newEnemy.Parent = game.Workspace
EnemyAIScript:Clone().Parent = newEnemy
