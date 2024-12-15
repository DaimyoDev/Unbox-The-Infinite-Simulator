local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LobbyEvent = ReplicatedStorage.Shared.Remote_Events.LobbyEvent
local lobbies = {}
local activePlayers = {}

local function updateClientLobbies(action)
    for _, player in activePlayers do
        LobbyEvent:FireClient(player, lobbies, action)
    end
end

local function initializeClientLobbies(player, action, lobbyData)
    if action == "joined" then
        table.insert(activePlayers, player)
        LobbyEvent:FireClient(player, lobbies)
    end
    if action == "createLobby" then
        local newLobby = {
            name = lobbyData.name,
            host = player,
            players = 1,
            playersData = {player}
        }
        table.insert(lobbies, newLobby)
        updateClientLobbies()
    end
    if action == "deleteLobby" then
        for i, lobby in lobbies do
            if lobby.name == lobbyData.name then
                table.remove(lobbies, i)
                break 
            end
        end
        updateClientLobbies("lobbyDeleted")
    end
    if action == "leftLobby" then
        for i, lobby in lobbies do
            if lobby.name == lobbyData.name then
                lobbies[i].players -= 1
                local currentLobby = lobbies[i].playersData
                for index, playerName in currentLobby do
                    if playerName == player then
                        table.remove(currentLobby, index)
                        updateClientLobbies()
                        break
                    end
                end
            break 
            end
        end
    end
    if action == "joinLobby" then
        for i, lobby in lobbies do
            if lobby.name == lobbyData.name then
                lobbies[i].players += 1
                table.insert(lobbies[i].playersData, player)
                updateClientLobbies()
                break
            end
        end
    end
end

LobbyEvent.OnServerEvent:Connect(initializeClientLobbies)