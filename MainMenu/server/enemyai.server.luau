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

local function findNewPlayer()
    if playerChosen then
        playerChosen = nil
    else
        findClosestPlayer()
    end
end

local agentParams = {
AgentRadius = 10,
AgentHeight = 1,
AgentCanJump = true,
AgentJumpHeight = 10
}
local path = PathFindingService:CreatePath(agentParams)
local reachedConnection
local nextWaypointIndex
local waypoints
local cooldown = false
local Client_Helpers = require(game.ReplicatedStorage.Shared.client_helpers)

local function chaseTarget(chosenPlayer)

    local playerPosition = chosenPlayer.Character.HumanoidRootPart.Position
    local destination = playerPosition + (chosenPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity) / 1.7
    chosenPlayer.Character.Humanoid.Died:Connect(function()
            findNewPlayer()
            return
        end)
    task.wait(0.1)
    cooldown = false
    Enemy.HumanoidRootPart.Touched:Connect(function(otherPart)
    local character = otherPart.Parent:FindFirstChild("Humanoid")
        if character ~= nil and cooldown == false then
            Client_Helpers.doDamage(character, character, 10)
            cooldown = true
        end
    end)

    local success = pcall(function()  
        path:ComputeAsync(Enemy.HumanoidRootPart.Position, destination)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        
        waypoints = path:GetWaypoints()
    
        for _, waypoint in waypoints do
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                Enemy.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(1)
                Enemy.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end
        if not reachedConnection then
            reachedConnection = Enemy.Humanoid.MoveToFinished:Connect(function(reached)
                if reached and nextWaypointIndex < #waypoints then
                    nextWaypointIndex += 1
                    Enemy.Humanoid:MoveTo(waypoints[nextWaypointIndex].Position, chosenPlayer.Character.HumanoidRootPart)
                end
            end)
        end
        nextWaypointIndex = 2
        Enemy.Humanoid:MoveTo(waypoints[nextWaypointIndex].Position, chosenPlayer.Character.HumanoidRootPart)
    end
end

while true do
    task.wait(0.1)
    if playerChosen then
        chaseTarget(playerChosen)
    else
        findNewPlayer()
    end
end