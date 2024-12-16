local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LobbyEvent = ReplicatedStorage.Shared.Remote_Events.LobbyEvent
local lobbies = {
    {name = "The Interesting Game", players = 5},
    {name = "Randomly Named Lobby", players = 3},
    {name = "Lobby 3", players = 10},
    {name = "Test.Exe", players = 7}
}
local activePlayers = {}

local function findLobbyByName(lobbyName)
    for index, lobby in ipairs(lobbies) do
        if lobby.name == lobbyName then
            return index, lobby
        end
    end
    return nil, nil
end

local function updateClientLobbies(action)
    for _, player in activePlayers do
        LobbyEvent:FireClient(player, lobbies, action)
    end
end

local lobbyActions = {
    joined = function(player, _lobbyData)
        table.insert(activePlayers, player)
        LobbyEvent:FireClient(player, lobbies)
    end,
    createLobby = function(player, lobbyData)
        local newLobby = {
            name = lobbyData.name,
            host = player,
            players = 1,
            playersData = {player}
        }
        table.insert(lobbies, newLobby)
        updateClientLobbies()
    end,
    deleteLobby = function(_player, lobbyData)
        local index = findLobbyByName(lobbyData.name)
        if index then
            table.remove(lobbies, index)
            updateClientLobbies("lobbyDeleted")
        end
    end,
    leftLobby = function(player, lobbyData)
        local _, lobby = findLobbyByName(lobbyData.name)
        if lobby then
            lobby.players -= 1
        end
        for index, playerName in lobby.playersData do
            if playerName == player then
                table.remove(lobby.playersData, index)
                updateClientLobbies()
            return
            end
        end
    end,
    joinLobby = function(player, lobbyData)
        local _, lobby = findLobbyByName(lobbyData.name)
        if lobby then
            lobby.players += 1
            table.insert(lobby.playersData, player)
            updateClientLobbies()
        end
    end
}

local function initializeClientLobbies(player, action, lobbyData)
    
    local actionFunction = lobbyActions[action]
    if actionFunction then
        actionFunction(player, lobbyData)
    end
end

LobbyEvent.OnServerEvent:Connect(initializeClientLobbies)