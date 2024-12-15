local client_helpers = {}
local LobbyList = require(script.Parent.UIComponents.LobbyList)
local LobbyEvent = game.ReplicatedStorage.Shared.Remote_Events.LobbyEvent

function client_helpers:doDamage(targetHumanoid, damage)
    targetHumanoid:TakeDamage(damage)
    targetHumanoid = nil
end

function client_helpers:loadMainMenu(React, PlayButtonClicked, root)
    local function MainMenu()
        return React.createElement("Frame", {
            Size = UDim2.new(1,0,1,0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(18, 121, 161)
        }, {
            React.createElement("TextButton", {
                Size = UDim2.new(0.2,0,0.1,0),
                Position = UDim2.new(0.4, 0, 0.4, 0),
                TextSize = 35,
                Text = "Play Game",
                TextColor3 = Color3.new(0, 0, 0),
                FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
                [React.Event.Activated] = function()
                    PlayButtonClicked:FireServer()
                    root.enabled = false
                    client_helpers:loadLobby(React, root)
                end
            }, React.createElement("UICorner", {
                CornerRadius = UDim.new(0.2, 0)
            }), React.createElement("UIGradient", {
                Color = ColorSequence.new(Color3.new(0.9, 0.9, 0.9), Color3.new(0.5, 0.5, 0.5)),
                Rotation = 45
            }))
        }, {
            React.createElement("TextButton", {
                Size = UDim2.new(0.2,0,0.1,0),
                Position = UDim2.new(0.4, 0, 0.53, 0),
                TextSize = 35,
                Text = "Daily Quests",
                TextColor3 = Color3.new(0, 0, 0),
                FontFace = Font.fromEnum(Enum.Font.SourceSansBold)
            }, React.createElement("UICorner", {
                CornerRadius = UDim.new(0.2, 0)
            }), React.createElement("UIGradient", {
                Color = ColorSequence.new(Color3.new(0.9, 0.9, 0.9), Color3.new(0.5, 0.5, 0.5)),
                Rotation = 45
            }))
        })
    end
    root:render(React.createElement(MainMenu, {}, {}))
end

function client_helpers:loadLobby(React, root)
    root:render(React.createElement(LobbyList, {}, {}))
    LobbyEvent:FireServer("joined")
end

return client_helpers