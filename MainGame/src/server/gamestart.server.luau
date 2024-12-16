local TeleportService = game:GetService("TeleportService")

game.Players.PlayerAdded:Connect(function(player)
    local teleportData = player:GetJoinData()
    print(teleportData)

end)