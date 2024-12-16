local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local UITheme = require(ReplicatedStorage.Shared.UIComponents.UITheme)
local ClientHelpers = require(ReplicatedStorage.Shared.client_helpers)

local MainMenu = React.Component:extend("MainMenu")

function MainMenu:init()
    self.state = {
        root = self.props.Root
    }
end

function MainMenu:render()
    return React.createElement("Frame", {
        Size = UDim2.new(1,0,1,0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = UITheme.CurrentTheme.BackgroundColor1
    }, {
        React.createElement("TextButton", {
            Size = UDim2.new(0.2,0,0.1,0),
            Position = UDim2.new(0.4, 0, 0.4, 0),
            TextSize = 35,
            Text = "Play Game",
            TextColor3 = Color3.new(0, 0, 0),
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            [React.Event.Activated] = function()
                self.state.root.enabled = false
                ClientHelpers:loadLobby(React, self.state.root)
            end
        }, React.createElement("UICorner", {
            CornerRadius = UDim.new(0.2, 0)
        }), React.createElement("UIGradient", {
            Color = ColorSequence.new(Color3.new(0.9, 0.9, 0.9), Color3.new(0.5, 0.5, 0.5)),
            Rotation = 45
        })), React.createElement("TextButton", {
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

return MainMenu