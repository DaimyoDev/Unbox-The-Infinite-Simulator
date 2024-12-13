local player = game:GetService("Players").LocalPlayer
local Humanoid
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerLoaded = ReplicatedStorage.Shared.Remote_Events.PlayerLoaded
local RespawnPlayer = ReplicatedStorage.Shared.Remote_Events.RespawnPlayer

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid") -- Wait for Humanoid to exist
    humanoid.Died:Connect(function()
        task.wait(2) -- Delay before respawn
        RespawnPlayer:FireServer()
    end)
end)

PlayerLoaded.OnClientEvent:Connect(function()
    Humanoid = player.Character.Humanoid
    Humanoid.Died:Connect(function()
        task.wait(2)
        RespawnPlayer:FireServer()
    end)
end)