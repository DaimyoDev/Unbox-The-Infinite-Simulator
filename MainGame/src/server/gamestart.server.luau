local GameFunctions = require(game.ReplicatedStorage.Shared.game_functions)
local Players = game:GetService("Players")
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
local Workspace = game:GetService("Workspace")
local spawnDelay = 1
local startingEnemies = TestRoundData.startingEnemyCount
local maxEnemies = 100
local currentRound = 0
local enemiesRemaining = 0
local enemiesFolder = Instance.new("Folder")
enemiesFolder.Parent = game.Workspace
enemiesFolder.Name = "Enemies"

local function getActiveMap()
    for _, child in Workspace:GetChildren() do
        if string.find(child.Name, "Map") then
            return child
        end
    end
    return nil
end

local function getSpawnPoints(map)
    local spawnModel = map:FindFirstChild("Spawn")
    if spawnModel and spawnModel:IsA("Model") then
        return spawnModel:GetChildren()
    end
    return {}
end

local function spawnEnemies(spawnPoints, count)
    for i = 1, count do
        task.wait(spawnDelay) -- Slight delay between spawns
        local randomSpawn = spawnPoints[math.random(1, #spawnPoints)]
        if randomSpawn and randomSpawn:IsA("BasePart") then
            local enemy = basicEnemyModel:Clone()
            enemy:SetPrimaryPartCFrame(CFrame.new(randomSpawn.Position + Vector3.new(0, 2, 0))) -- Spawn on top of spawn point
            enemy.Parent = enemiesFolder

            -- Add AI script to the enemy
            local aiScript = EnemyAIScript:Clone()
            aiScript.Parent = enemy

            enemiesRemaining += 1

            -- Simulate enemy destruction
            task.delay(math.random(30, 60), function() -- Placeholder for enemy "lifetime"
                if enemy and enemy.Parent then
                    enemy:Destroy()
                    enemiesRemaining -= 1
                end
            end)
        end
    end
end

local function startRoundSystem()
    local map = getActiveMap()
    if not map then
        warn("No active map found!")
        return
    end

    local spawnPoints = getSpawnPoints(map)
    if #spawnPoints == 0 then
        warn("No spawn points found in the map!")
        return
    end

    local spawnCount = startingEnemies

    while spawnCount <= maxEnemies do
        currentRound += 1
        print("Starting round", currentRound)

        spawnEnemies(spawnPoints, spawnCount)

        -- Wait until all enemies are eliminated
        while enemiesRemaining > 0 do
            task.wait(1)
        end

        print("Round", currentRound, "completed!")

        spawnCount = math.min(spawnCount + 1, maxEnemies)
    end

    print("All rounds completed!")
end

startRoundSystem()