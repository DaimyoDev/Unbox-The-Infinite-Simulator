local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RespawnPlayer = ReplicatedStorage.Shared.Remote_Events.RespawnPlayer
local character = Player.Character
local humanoid = character:WaitForChild("Humanoid")

humanoid.Died:Connect(function()
    task.wait(2)
    RespawnPlayer:FireServer()
end)