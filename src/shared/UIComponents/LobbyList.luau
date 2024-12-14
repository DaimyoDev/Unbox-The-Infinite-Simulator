local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)


local LobbyList = React.Component:extend("LobbyList")

function LobbyList:init()
    self.state = {
        lobbies = {
            {id = 1, name = "Lobby A", players = 3},
            {id = 2, name = "Lobby B", players = 5},
            {id = 3, name = "Lobby C", players = 2}
        }
    }

    self.addLobbyItem = function()
        self:setState(function(prevState)
            local newLobbies = prevState.lobbies
            local newLobbyNumber = #newLobbies + 1
            table.insert(newLobbies, {name = `Lobby {newLobbyNumber}`, players = math.random(1, 10)})
            return {lobbies = newLobbies}
        end)
    end

end

function LobbyList:render()
    return React.createElement("ScrollingFrame", {
        Size = UDim2.new(0.5, 0, 1.1, 0),
        Position = UDim2.new(0.24, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(13, 89, 119),
        BorderColor3 = Color3.fromRGB(13, 89, 119),
        CanvasSize = UDim2.new(0, 0, 1, #self.state.lobbies * 50),
        ScrollBarThickness = 10
    }, self:renderLobbyItems(), {React.createElement("UIPadding", {
        PaddingTop = UDim.new(0.05, 0)
    })}, {
        AddButton = React.createElement("TextButton", {
            Text = "Add Lobby Item",
            Size = UDim2.new(0.2, 0, 0.05, 0),
            Position = UDim2.new(0.4, 0, 0.85, 0),
            BackgroundColor3 = Color3.fromRGB(100, 200, 100),
            TextScaled = true,
            [React.Event.Activated] = self.addLobbyItem
        })
    })
end

function LobbyList:renderLobbyItems()
    local lobbyComponents = {}

    for index, lobby in self.state.lobbies do
        table.insert(lobbyComponents, React.createElement("Frame", {
            Size = UDim2.new(0.8, 0, 0, 40),
            Position = UDim2.new(0.5, 0, 0, (index - 1) * 55),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 2
        }, {
            LobbyName = React.createElement("TextLabel", {
                Text = lobby.name .. " - Players: " .. lobby.players,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                TextColor3 = Color3.fromRGB(0, 0, 0),
                TextScaled = true,
                BackgroundTransparency = 1,
            })
        }))
    end
    return lobbyComponents
end

return LobbyList