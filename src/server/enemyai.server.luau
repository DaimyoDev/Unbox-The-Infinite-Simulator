local Enemy = script.Parent
if not script.Parent:IsA("Model") then
    return
end

local legColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
local skinColor = Color3.fromRGB(245, 205, 48)
Enemy.Torso.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
Enemy["Left Leg"].Color, Enemy["Right Leg"].Color = legColor, legColor
Enemy.Head.Color = skinColor
Enemy["Left Arm"].Color = skinColor
Enemy["Right Arm"].Color = skinColor

local PathFindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players"):GetChildren()
local playerData = {}
local playerDistances = {}
for _, player in Players do
    local distanceX = math.abs(math.floor(Enemy.HumanoidRootPart.Position.X - player.Character.HumanoidRootPart.Position.X))
    local distanceZ = math.abs(math.floor(Enemy.HumanoidRootPart.Position.Z - player.Character.HumanoidRootPart.Position.Z))
    local distance = distanceX + distanceZ
    table.insert(playerData, {name = player, distance = distance})
end

for _, player in playerData do
        table.insert(playerDistances, player["distance"])
end

table.sort(playerDistances)
local chosenPlayer = playerDistances[1]
local playerChosen = false

for _, player in playerData do
    if chosenPlayer == player["distance"] then
        chosenPlayer = player["name"]
        playerChosen = true
    end
end
local agentParams = {
AgentRadius = 2,
AgentHeight = 1,
AgentCanJump = true,
AgentJumpHeight = 10
}
local path = PathFindingService:CreatePath(agentParams)
local reachedConnection
local nextWaypointIndex
local waypoints
local walkAnimation = Instance.new("Animation")
walkAnimation.AnimationId = "http://www.roblox.com/asset/?id=180426354"
local walkAnimationTrack = Enemy.Humanoid:LoadAnimation(walkAnimation)
local walkAnimationPlaying = false

while playerChosen do
    task.wait(0.1)
    local success = pcall(function()  
        path:ComputeAsync(Enemy.HumanoidRootPart.Position, chosenPlayer.Character.HumanoidRootPart.Position)
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
                    Enemy.Humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
                else
                    walkAnimationPlaying = false
                    walkAnimationTrack:Stop()
                end
            end)
        end
        nextWaypointIndex = 2
        Enemy.Humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
        if not walkAnimationPlaying then
            walkAnimationPlaying = true
            walkAnimationTrack:Play()
        end
    end
end