local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local LobbyEvent = ReplicatedStorage.Shared.Remote_Events.LobbyEvent


local LobbyList = React.Component:extend("LobbyList")

function LobbyList:init()
    self.state = {
        lobbies = {},
        isCreatingLobby = false,
        isInLobby = false,
        currentLobby = {}
    }

    LobbyEvent.OnClientEvent:Connect(function(Newlobbies, action) 
        self:setState({lobbies = Newlobbies})
        if action == "lobbyDeleted" then
            self:setState({
                isCreatingLobby = false,
                isInLobby = false,
                currentLobby = "None"
            })
        end
    end)

end

function LobbyList:createLobby()
    self:setState({isCreatingLobby = true})
end

function LobbyList:createLobbyFromInput(text, player)
    local LobbyData = {name = text, host = player, playersData = {player}}
    LobbyEvent:FireServer("createLobby", LobbyData)
    table.insert(self.state.lobbies, LobbyData)
        
    self:setState({
        isCreatingLobby = false,
        isInLobby = true,
        currentLobby = LobbyData
    })
end

function LobbyList:backToLobbyList(player)
    for index, lobby in self.state.lobbies do
        if lobby.name == self.state.currentLobby.name then
            if lobby.host == player then
                table.remove(self.state.lobbies, index)
                LobbyEvent:FireServer("deleteLobby", lobby)
            else
                LobbyEvent:FireServer("leftLobby", lobby)
            end
        end
    end

    self:setState({
        isCreatingLobby = false,
        isInLobby = false,
        currentLobby = "None"
    })
end

function LobbyList:renderIsInLobbyUI()
    local isHost = false
    if self.state.currentLobby.host == game.Players.LocalPlayer then
        isHost = true
    end

    return React.createElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromHex("#344E41")
    }, {
        React.createElement("TextLabel", {
            Text = "In Lobby: " .. self.state.currentLobby.name,
            Size = UDim2.new(1, 0, 0.2, 0),
            TextColor3 = Color3.fromHex("#DAD7CD"),
            BackgroundColor3 = Color3.fromHex("#344E41"),
            TextScaled = true,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold)
        }, {React.createElement("UIPadding", {PaddingBottom = UDim.new(0, 30)})}), React.createElement("Frame", {
            Size = UDim2.new(1, 0, 0.7, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = Color3.fromHex("#344E41"),
            BorderSizePixel = 0
        }, self:renderInLobbyItems()),
        React.createElement("TextButton", {
            Text = "Back to Lobby List",
            TextColor3 = Color3.fromHex("#344E41"),
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.1, 0, 0.8, 0),
            BackgroundColor3 = Color3.fromHex("#DAD7CD"),
            TextScaled = true,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            [React.Event.Activated] = function()
                self:backToLobbyList(game.Players.LocalPlayer)
            end
        }, {React.createElement("UICorner", {CornerRadius = UDim.new(0, 20)}), React.createElement("UIPadding", {
            PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20)
        })}), isHost and React.createElement("TextButton", {
            Text = "Start Game",
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.7, 0, 0.8, 0),
            BackgroundColor3 = Color3.fromRGB(200, 100, 100),
            TextScaled = true,
            [React.Event.Activated] = function()
                print("start!")
            end
        }) or nil
    })
end

function LobbyList:renderCreateLobbyUI()
    return React.createElement("Frame", {
        Size = UDim2.new(1, 0, 1.1, 0),
        Position = UDim2.new(0, 0, -0.1, 0),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    }, {
        Title = React.createElement("TextLabel", {
            Text = "Create a New Lobby",
            Size = UDim2.new(1, 0, 0.1, 0),
            BackgroundColor3 = Color3.fromRGB(150, 150, 150),
            TextScaled = true
        }),
        InputBox = React.createElement("TextBox", {
            PlaceholderText = "Enter Lobby Name",
            Size = UDim2.new(0.5, 0, 0.1, 0),
            Position = UDim2.new(0.25, 0, 0.3, 0),
            TextScaled = true,
            [React.Event.FocusLost] = function(rbx, enterPressed)
                if enterPressed then
                    local player = game.Players.LocalPlayer
                    self:createLobbyFromInput(rbx.Text, player)
                end
            end
        }),
        BackButton = React.createElement("TextButton", {
            Text = "Back to Lobby List",
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.1, 0, 0.7, 0),
            BackgroundColor3 = Color3.fromRGB(100, 200, 100),
            TextScaled = true,
            [React.Event.Activated] = function()
                self:backToLobbyList()
            end
        })
    })
end

function LobbyList:render()
    if self.state.isCreatingLobby then
        return self:renderCreateLobbyUI()
    end
    if self.state.isInLobby then
        return self:renderIsInLobbyUI()
    end

    local totalLobbies = #self.state.lobbies
    local canvasHeight = totalLobbies * 55

    return React.createElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromHex("#344E41"),
        Position = UDim2.new(0, 0, 0, 0)

    }, {
        ScrollingFrame = React.createElement("ScrollingFrame", {
            Size = UDim2.new(0.9, 0, 0.8, 0),
            Position = UDim2.new(0.5, 0, 0.17, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            CanvasSize = UDim2.new(0, 0, 0, canvasHeight),
            BackgroundColor3 = Color3.fromHex("#080808"),
            BorderSizePixel = 0,
            ScrollBarThickness = 10,
            BackgroundTransparency = 1
        }, self:renderLobbyItems(), {
            React.createElement("UIPadding", {PaddingTop = UDim.new(0, 10)}), React.createElement("UIGridLayout", {
                HorizontalAlignment = "Center",
                VerticalAlignment = "Center",
                CellSize = UDim2.new(0, 600, 0, 150),
                CellPadding = UDim2.new(0, 30, 0, 30)
            })
        }),
        AddButton = React.createElement("TextButton", {
            Text = "Create Lobby",
            TextColor3 = Color3.fromHex("#3A5A40"),
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.4, 0, 0.1, 0),
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromHex("#DAD7CD"),
            TextScaled = true,
            [React.Event.Activated] = function()
                self:createLobby()
            end
        }, {React.createElement("UICorner", {CornerRadius = UDim.new(0, 20)}), React.createElement("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20)})})
    })
end


function LobbyList:renderLobbyItems()
    local lobbyComponents = {}

    for index, lobby in self.state.lobbies do
        table.insert(lobbyComponents, React.createElement("Frame", {
            Size = UDim2.new(0.8, 0, 0, 40),
            Position = UDim2.new(0.5, 0, 0, (index - 1) * 55),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromHex("#DAD7CD"),
            BorderColor3 = Color3.fromHex("#3A5A40"),
            BorderSizePixel = 2
        }, {
            LobbyName = React.createElement("TextButton", {
                Text = lobby.name .. " Players: " .. lobby.players,
                BackgroundColor3 = Color3.fromHex("#DAD7CD"),
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                TextColor3 = Color3.fromHex("#3A5A40"),
                TextScaled = false,
                TextSize = 40,
                BackgroundTransparency = 1,
                FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
                [React.Event.Activated] = function()
                    LobbyEvent:FireServer("joinLobby", lobby)
                    self:setState({isInLobby = true, currentLobby = lobby})
                end
            }), LobbyPadding = React.createElement("UIPadding", {
                PaddingTop = UDim.new(0, 20),
                PaddingBottom = UDim.new(0, 20),
                PaddingLeft = UDim.new(0, 20),
                PaddingRight = UDim.new(0, 20)
            }), LobbyRoundCorners = React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 20)
            })
        }))
    end
    return lobbyComponents
end

function LobbyList:renderInLobbyItems()
    local inLobbyComponents = {}
    for _, lobby in self.state.lobbies do
        if lobby.name == self.state.currentLobby.name then
            for index, player in lobby.playersData do
                if lobby.host == player then
                    table.insert(inLobbyComponents, React.createElement("Frame", {
                        Size = UDim2.new(0.8, 0, 0, 40),
                        Position = UDim2.new(0.5, 0, 0, (index - 1) * 55),
                        AnchorPoint = Vector2.new(0.5, 0),
                        BackgroundColor3 = Color3.fromHex("DAD7CD"),
                        BorderColor3 = Color3.fromHex("A3B18A"),
                        BorderSizePixel = 2
                    }, {
                        LobbyName = React.createElement("TextButton", {
                            Text = `Host: {player.Name}`,
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0, 5, 0, 0),
                            TextColor3 = Color3.fromHex("#3b3d16"),
                            TextScaled = true,
                            BackgroundTransparency = 1,
                            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
                        })
                    }))
                else
                    table.insert(inLobbyComponents, React.createElement("Frame", {
                        Size = UDim2.new(0.8, 0, 0, 40),
                        Position = UDim2.new(0.5, 0, 0, (index - 1) * 55),
                        AnchorPoint = Vector2.new(0.5, 0),
                        BackgroundColor3 = Color3.fromHex("DAD7CD"),
                        BorderColor3 = Color3.fromHex("A3B18A"),
                        BorderSizePixel = 2
                    }, {
                        LobbyName = React.createElement("TextButton", {
                            Text = player.Name,
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0, 5, 0, 0),
                            TextColor3 = Color3.fromHex("344E41"),
                            TextScaled = true,
                            BackgroundTransparency = 1,
                            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
                        })
                    }))
                end
            end
            break
        end
    end
    return inLobbyComponents
end

return LobbyList