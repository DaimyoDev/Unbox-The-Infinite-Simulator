local Enemy = script.Parent
if not script.Parent:IsA("Model") then return end

local legColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
local skinColor = Color3.fromRGB(245, 205, 48)
Enemy.Torso.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
Enemy["Left Leg"].Color, Enemy["Right Leg"].Color = legColor, legColor
Enemy.Head.Color = skinColor
Enemy["Left Arm"].Color = skinColor
Enemy["Right Arm"].Color = skinColor
local playerChosen

legColor = nil
skinColor = nil

Enemy.Humanoid.WalkSpeed = 30
task.wait(3)
local PathFindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players"):GetChildren()

local function findClosestPlayer()
    local playerData = {}
    local playerDistances = {}
    for _, player in Players do
        if player.Character.Humanoid.Health > 0 then
            local distanceX = math.abs(Enemy.HumanoidRootPart.Position.X - player.Character.HumanoidRootPart.Position.X)
            local distanceZ = math.abs(Enemy.HumanoidRootPart.Position.Z - player.Character.HumanoidRootPart.Position.Z)
            local distance = distanceX + distanceZ
            table.insert(playerData, {name = player, distance = distance})
        end
    end

    for _, player in playerData do
        table.insert(playerDistances, player["distance"])

        table.sort(playerDistances)
        local chosenPlayer = playerDistances[1]
        
        for _, playerItem in playerData do
            if chosenPlayer == playerItem["distance"] then
                chosenPlayer = playerItem["name"]
                playerChosen = chosenPlayer
            end
        end
    end
end

findClosestPlayer()
if playerChosen == nil then
    findClosestPlayer()
end

local function findNewPlayer()
    if playerChosen then
        playerChosen = nil
    else
        findClosestPlayer()
    end
end

local agentParams = {
AgentRadius = 1,
AgentHeight = 1,
AgentCanJump = true,
AgentJumpHeight = 10,
AgentCanClimb = true,
WaypointSpacing = 2
}
local path = PathFindingService:CreatePath(agentParams)
local reachedConnection
local nextWaypointIndex = 1
local waypoints
local cooldown = false
local GameFunctions = require(game.ReplicatedStorage.Shared.game_functions)
local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
local lastPosition = nil

local function chaseTarget(chosenPlayer)

    local playerPosition = chosenPlayer.Character.HumanoidRootPart.Position
    local destination = playerPosition + (chosenPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity) / 3

    local direction = (destination - Enemy.HumanoidRootPart.Position).Unit
    local distance = (destination - Enemy.HumanoidRootPart.Position).Magnitude
    local rayParams = RaycastParams.new()

    local ignoreList = {chosenPlayer.Character}
    for _, enemy in enemiesFolder:GetChildren() do
        if enemy:IsA("Model") then
            table.insert(ignoreList, enemy)
        end
    end

    rayParams.FilterDescendantsInstances = ignoreList
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycastResult = workspace:Raycast(Enemy.HumanoidRootPart.Position, direction * distance, rayParams)

    if raycastResult then
        local currentPosition = playerChosen.Character.PrimaryPart.Position
        if lastPosition and (currentPosition - lastPosition).Magnitude > 1 then
            print("player moved and raycast")
            local success = pcall(function()  
                path:ComputeAsync(Enemy.HumanoidRootPart.Position, destination)
            end)
            if success and path.Status == Enum.PathStatus.Success then
        
                waypoints = path:GetWaypoints()
        
                if not reachedConnection then
                    reachedConnection = Enemy.Humanoid.MoveToFinished:Connect(function(reached)
                        if reached and nextWaypointIndex < #waypoints then
                            nextWaypointIndex += 1
                            Enemy.Humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
                            if waypoints[nextWaypointIndex].Action == Enum.PathWaypointAction.Jump then
                                Enemy.Humanoid.Jump = true
                            end
                        end
                    end)
                end
                nextWaypointIndex = 2
                Enemy.Humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
            end
        end
        lastPosition = currentPosition
    else
        Enemy.Humanoid:MoveTo(destination)
    end
end

while Enemy.Humanoid.Health > 0 do
    task.wait(0.1)
    if playerChosen then
        chaseTarget(playerChosen)
    else
        findNewPlayer()
    end
end