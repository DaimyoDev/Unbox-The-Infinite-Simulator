local basicEnemyModel = game.ServerStorage["Enemy Noob"]
local EnemyAIScript = game.ServerScriptService.Server.enemyai
--get playbutton clicked, select a map, get all players in the lobby, get them all to spawn at the map spawn. Get the difficulty settings for the bots.
--[[
local newEnemy = basicEnemyModel:Clone()
newEnemy.Parent = game.Workspace
EnemyAIScript:Clone().Parent = newEnemy
]]

