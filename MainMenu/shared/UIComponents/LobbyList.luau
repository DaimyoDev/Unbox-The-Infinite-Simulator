local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local LobbyEvent = ReplicatedStorage.Shared.Remote_Events.LobbyEvent
local UITheme = require(ReplicatedStorage.Shared.UIComponents.UITheme)
local BasicTextButton = require(ReplicatedStorage.Shared.UIComponents.BasicTextButton)
local PlayButtonClicked = ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked

local LobbyList = React.Component:extend("LobbyList")

function LobbyList:init()
    self.state = {
        lobbies = {},
        isCreatingLobby = false,
        isInLobby = false,
        currentLobby = {},
        creatingLobbyData = {
            name = `{game.Players.LocalPlayer.Name}'s Lobby`,
            host = game.Players.LocalPlayer,
            players = 1,
            playersData = {game.Players.LocalPlayer},
            waves = 10,
            difficulty = 1,
            lives = 5
        }
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

function LobbyList:createLobbyFromInput()
    LobbyEvent:FireServer("createLobby", self.state.creatingLobbyData)
    table.insert(self.state.lobbies, self.state.creatingLobbyData)
        
    self:setState({
        isCreatingLobby = false,
        isInLobby = true,
        currentLobby = self.state.creatingLobbyData,                   
        creatingLobbyData = {
            name = `{game.Players.LocalPlayer.Name}'s Lobby`,
            host = game.Players.LocalPlayer,
            players = 1,
            playersData = {game.Players.LocalPlayer},
            waves = self.state.creatingLobbyData.waves,
            difficulty = 1,
            lives = 5
        }
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
        BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor1
    }, {
        React.createElement("TextLabel", {
            Text = "In Lobby: " .. self.state.currentLobby.name,
            Size = UDim2.new(1, 0, 0.2, 0),
            TextColor3 = UITheme.CurrentTheme.BackgroundTextColor,
            BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor1,
            TextScaled = true,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold)
        }, {
            React.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 30)
        })
        }), React.createElement("Frame", {
            Size = UDim2.new(1, 0, 0.7, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor1,
            BorderSizePixel = 0
        }, self:renderInLobbyItems()), 
        React.createElement(BasicTextButton, {
            Text = "Back to Lobby List",
            Position = UDim2.new(0.1, 0, 0.8, 0),
            TextScaled = true,
            OnClick = function()
                self:backToLobbyList(game.Players.LocalPlayer)
            end
        }),
        isHost and React.createElement(BasicTextButton, {
            Text = "Start Game",
            Size = UDim2.new(0.2, 0, 0.1, 0),
            Position = UDim2.new(0.7, 0, 0.8, 0),
            BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor3,
            TextScaled = true,
            OnClick = function()
                for _, lobby in self.state.lobbies do
                    if lobby.name == self.state.currentLobby.name then
                        PlayButtonClicked:FireServer(lobby)
                    end
                end
            end
        }) or nil
    })
end

function LobbyList:renderCreateLobbyUI()
    return React.createElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor1,
        BorderSizePixel = 0,
    }, {
        Title = React.createElement("TextLabel", {
            Text = "Create a New Lobby",
            TextColor3 = UITheme.CurrentTheme.BackgroundTextColor,
            Size = UDim2.new(1, 0, 0.1, 0),
            BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor1,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            BorderSizePixel = 0,
            TextScaled = true
        }),
        InputBox = React.createElement("TextBox", {
            Text = "Enter lobby name, press Enter to set a name",
            PlaceholderText = "Enter lobby name, press Enter to set a name",
            PlaceholderColor3 = UITheme.CurrentTheme.BackgroundTextColor,
            Size = UDim2.new(0.5, 0, 0.1, 0),
            Position = UDim2.new(0.25, 0, 0.3, 0),
            TextColor3 = UITheme.CurrentTheme.BackgroundTextColor,
            BorderSizePixel = 0,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor3,
            TextScaled = true,
            [React.Event.FocusLost] = function(rbx, enterPressed)
                if enterPressed then
                    if string.len(rbx.Text) > 0 then
                        self:setState({
                            creatingLobbyData = {
                                name = rbx.Text,
                                host = self.state.creatingLobbyData.host,
                                players = self.state.creatingLobbyData.players,
                                playersData = self.state.creatingLobbyData.playersData,
                                waves = self.state.creatingLobbyData.waves,
                                difficulty = self.state.creatingLobbyData.difficulty,
                                lives = self.state.creatingLobbyData.lives
                            }
                        })
                    end
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
        WavesInput = React.createElement("TextBox", {
            Text = "How many waves? Press enter to set the amount",
            PlaceholderText = "How many waves? Press enter to set the amount",
            PlaceholderColor3 = UITheme.CurrentTheme.BackgroundTextColor,
            Size = UDim2.new(0.5, 0, 0.1, 0),
            Position = UDim2.new(0.25, 0, 0.5, 0),
            TextColor3 = UITheme.CurrentTheme.BackgroundTextColor,
            BorderSizePixel = 0,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor3,
            TextScaled = true,
            [React.Event.FocusLost] = function(rbx, enterPressed)
                if enterPressed then
                    if string.len(rbx.Text) > 0 then
                        self:setState({
                            creatingLobbyData = {
                                name = self.state.creatingLobbyData.name,
                                host = self.state.creatingLobbyData.host,
                                players = self.state.creatingLobbyData.players,
                                playersData = self.state.creatingLobbyData.playersData,
                                waves = tonumber(rbx.Text),
                                difficulty = self.state.creatingLobbyData.difficulty,
                                lives = self.state.creatingLobbyData.lives
                            }
                        })
                    end
                end
            end
        }),
        BackButton = React.createElement(BasicTextButton, {
            Text = "Back to Lobby List",
            Position = UDim2.new(0.1, 0, 0.7, 0),
            TextScaled = true,
            OnClick = function()
                self:backToLobbyList()
            end
        }),
        CreateLobbyButton = React.createElement(BasicTextButton, {
            Text = "Create Lobby",
            Position = UDim2.new(0.7, 0, 0.7, 0),
            TextScaled = true,
            OnClick = function()
                if string.len(self.state.creatingLobbyData.name) > 0 then
                    self:setState({
                        creatingLobbyData = {
                            name = self.state.creatingLobbyData.name,
                            host = self.state.creatingLobbyData.host,
                            players = self.state.creatingLobbyData.players,
                            playersData = self.state.creatingLobbyData.playersData,
                            waves = self.state.creatingLobbyData.waves,
                            difficulty = self.state.creatingLobbyData.difficulty,
                            lives = self.state.creatingLobbyData.lives
                        }
                    })
                end
                self:createLobbyFromInput()
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
        BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor1,
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
            React.createElement("UIPadding", {PaddingTop = UDim.new(0, 10)}), 
            React.createElement("UIGridLayout", {
                HorizontalAlignment = "Center",
                VerticalAlignment = "Center",
                CellSize = UDim2.new(0, 600, 0, 150),
                CellPadding = UDim2.new(0, 30, 0, 30)
            })
        }),
        AddButton = React.createElement(BasicTextButton, {
            Text = "Create Lobby",
            Position = UDim2.new(0.4, 0, 0.1, 0),
            TextScaled = true,
            OnClick = function()
                self:createLobby()
            end
        })
    })
end


function LobbyList:renderLobbyItems()
    local lobbyComponents = {}

    for _, lobby in self.state.lobbies do
        table.insert(lobbyComponents, React.createElement(BasicTextButton, {
                Text = lobby.name .. " Players: " .. lobby.players,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                TextScaled = false,
                TextSize = 40,
                OnClick = function()
                    LobbyEvent:FireServer("joinLobby", lobby)
                    self:setState({isInLobby = true, currentLobby = lobby})
                end
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
                        BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor2,
                        BorderColor3 = UITheme.CurrentTheme.BackgroundColor3,
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
                        BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor2,
                        BorderColor3 = UITheme.CurrentTheme.BackgroundColor3,
                        BorderSizePixel = 2
                    }, {
                        LobbyName = React.createElement("TextLabel", {
                            Text = player.Name,
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0, 5, 0, 0),
                            TextScaled = true,
                            BackgroundTransparency = 1,
                            FontFace = Font.fromEnum(Enum.Font.SourceSansBold)
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