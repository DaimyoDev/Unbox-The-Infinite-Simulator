local PlayButtonClicked = game.ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
local TeleportService = game:GetService("TeleportService")
local RoundSettings = {
    waves = nil,
    difficulty = nil,
    lives = nil,
    startingEnemyCount = 5
}

PlayButtonClicked.OnServerEvent:Connect(function(_lobby, lobby2)
    RoundSettings["waves"] = lobby2.waves
    RoundSettings["difficulty"] = lobby2.difficulty
    RoundSettings["lives"] = lobby2.lives
    local players = {}

    for _, player in lobby2.playersData do
        table.insert(players, player)
    end

    local teleportOptions = Instance.new("TeleportOptions")
    teleportOptions:SetTeleportData(RoundSettings)

    TeleportService:TeleportAsync(135989830819537, players, teleportOptions)

end)