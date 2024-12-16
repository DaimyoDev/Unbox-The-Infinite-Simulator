local Player = game:GetService("Players").LocalPlayer
local Humanoid
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerLoaded = ReplicatedStorage.Shared.Remote_Events.PlayerLoaded
local RespawnPlayer = ReplicatedStorage.Shared.Remote_Events.RespawnPlayer

Player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        task.wait(2)
        RespawnPlayer:FireServer()
    end)
end)

PlayerLoaded.OnClientEvent:Connect(function()
    Humanoid = Player.Character.Humanoid
    Humanoid.Died:Connect(function()
        task.wait(2)
        RespawnPlayer:FireServer()
    end)
end)