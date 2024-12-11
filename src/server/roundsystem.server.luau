local basicEnemyModel = game.ServerStorage["Enemy Noob"]
local EnemyAIScript = game.ServerScriptService.Server.enemyai

while true do
    task.wait(2)
    local newEnemy = basicEnemyModel:Clone()
    newEnemy.Parent = game.Workspace
    EnemyAIScript:Clone().Parent = newEnemy
end