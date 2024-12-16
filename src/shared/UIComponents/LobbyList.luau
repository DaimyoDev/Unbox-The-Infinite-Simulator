local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local LobbyEvent = ReplicatedStorage.Shared.Remote_Events.LobbyEvent
local UITheme = require(ReplicatedStorage.Shared.UIComponents.UITheme)


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
        BackgroundColor3 = UITheme.GreenTheme.BackgroundColor1
    }, {
        React.createElement("TextLabel", {
            Text = "In Lobby: " .. self.state.currentLobby.name,
            Size = UDim2.new(1, 0, 0.2, 0),
            TextColor3 = UITheme.GreenTheme.BackgroundTextColor,
            BackgroundColor3 = UITheme.GreenTheme.BackgroundColor1,
            TextScaled = true,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold)
        }, {
            React.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 30)
        })
        }), React.createElement("Frame", {
            Size = UDim2.new(1, 0, 0.7, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = UITheme.GreenTheme.BackgroundColor1,
            BorderSizePixel = 0
        }, self:renderInLobbyItems()),
        React.createElement("TextButton", {
            Text = "Back to Lobby List",
            TextColor3 = UITheme.GreenTheme.TextColor,
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.1, 0, 0.8, 0),
            BackgroundColor3 = Color3.fromHex("#DAD7CD"),
            TextScaled = true,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            [React.Event.Activated] = function()
                self:backToLobbyList(game.Players.LocalPlayer)
            end
        }, {React.createElement("UICorner", {CornerRadius = UDim.new(0, 20)}), 
        React.createElement("UIPadding", {
            PaddingTop = UDim.new(0, 10), 
            PaddingBottom = UDim.new(0, 10), 
            PaddingLeft = UDim.new(0, 20), 
            PaddingRight = UDim.new(0, 20)
        })}), isHost and React.createElement("TextButton", {
            Text = "Start Game",
            TextColor3 = UITheme.GreenTheme.TextColor,
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.7, 0, 0.8, 0),
            BackgroundColor3 = Color3.fromHex("#A3B18A"),
            TextScaled = true,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            [React.Event.Activated] = function()
                print("start!")
            end
        }, {React.createElement("UICorner", {CornerRadius = UDim.new(0, 20)}), 
        React.createElement("UIPadding", {
            PaddingTop = UDim.new(0, 10), 
            PaddingBottom = UDim.new(0, 10), 
            PaddingLeft = UDim.new(0, 20), 
            PaddingRight = UDim.new(0, 20)
        })}) or nil
    })
end

function LobbyList:renderCreateLobbyUI()
    return React.createElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = UITheme.GreenTheme.BackgroundColor1,
        BorderSizePixel = 0,
    }, {
        Title = React.createElement("TextLabel", {
            Text = "Create a New Lobby",
            TextColor3 = UITheme.GreenTheme.BackgroundTextColor,
            Size = UDim2.new(1, 0, 0.1, 0),
            BackgroundColor3 = UITheme.GreenTheme.BackgroundColor1,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            BorderSizePixel = 0,
            TextScaled = true
        }),
        InputBox = React.createElement("TextBox", {
            PlaceholderText = "Enter Lobby Name",
            PlaceholderColor3 = UITheme.GreenTheme.BackgroundTextColor,
            Size = UDim2.new(0.5, 0, 0.1, 0),
            Position = UDim2.new(0.25, 0, 0.3, 0),
            TextColor3 = UITheme.GreenTheme.BackgroundTextColor,
            BorderSizePixel = 0,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            BackgroundColor3 = Color3.fromHex("#3A5A40"),
            TextScaled = true,
            [React.Event.FocusLost] = function(rbx, enterPressed)
                if enterPressed then
                    local player = game.Players.LocalPlayer
                    self:createLobbyFromInput(rbx.Text, player)
                end
            end
        }, {
            React.createElement("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 20),
                PaddingRight = UDim.new(0, 20)
            }),
            React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 20)
            })
        }),
        BackButton = React.createElement("TextButton", {
            Text = "Back to Lobby List",
            TextColor3 = UITheme.GreenTheme.TextColor,
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.1, 0, 0.7, 0),
            BackgroundColor3 = UITheme.GreenTheme.BackgroundColor2,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            TextScaled = true,
            BorderSizePixel = 0,
            [React.Event.Activated] = function()
                self:backToLobbyList()
            end
        }, {
            React.createElement("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 20),
                PaddingRight = UDim.new(0, 20)
            }),
            React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 20)
            })
        }), CreateLobbyText = React.createElement("TextLabel", {
            Text = "Press Enter To Create The Lobby",
            TextColor3 = UITheme.GreenTheme.TextColor,
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.4, 0, 0.17, 0),
            BackgroundColor3 = UITheme.GreenTheme.BackgroundColor2,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            TextScaled = true,
            BorderSizePixel = 0
            
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
        BackgroundColor3 = UITheme.GreenTheme.BackgroundColor1,
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
            BackgroundColor3 = UITheme.GreenTheme.BackgroundColor2,
            TextScaled = true,
            [React.Event.Activated] = function()
                self:createLobby()
            end
        }, {
            React.createElement("UICorner", 
            {
                CornerRadius = UDim.new(0, 20)
            }), React.createElement("UIPadding", {
                PaddingTop = UDim.new(0, 10), 
                PaddingBottom = UDim.new(0, 10), 
                PaddingLeft = UDim.new(0, 20), 
                PaddingRight = UDim.new(0, 20)
            })})
    })
end


function LobbyList:renderLobbyItems()
    local lobbyComponents = {}

    for index, lobby in self.state.lobbies do
        table.insert(lobbyComponents, React.createElement("Frame", {
            Size = UDim2.new(0.8, 0, 0, 40),
            Position = UDim2.new(0.5, 0, 0, (index - 1) * 55),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = UITheme.GreenTheme.BackgroundColor2,
            BorderColor3 = Color3.fromHex("#3A5A40"),
            BorderSizePixel = 2
        }, {
            LobbyName = React.createElement("TextButton", {
                Text = lobby.name .. " Players: " .. lobby.players,
                BackgroundColor3 = UITheme.GreenTheme.BackgroundColor2,
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
                        BackgroundColor3 = UITheme.GreenTheme.BackgroundColor2,
                        BorderColor3 = Color3.fromHex("#A3B18A"),
                        BorderSizePixel = 2
                    }, {
                        LobbyName = React.createElement("TextButton", {
                            Text = `Host: {player.Name}`,
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0, 5, 0, 0),
                            TextColor3 = Color3.fromHex("#c1121f"),
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
                        BackgroundColor3 = UITheme.GreenTheme.BackgroundColor2,
                        BorderColor3 = Color3.fromHex("#A3B18A"),
                        BorderSizePixel = 2
                    }, {
                        LobbyName = React.createElement("TextButton", {
                            Text = player.Name,
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0, 5, 0, 0),
                            TextColor3 = UITheme.GreenTheme.BackgroundColor1,
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