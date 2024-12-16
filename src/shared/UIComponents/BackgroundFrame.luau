local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local UITheme = require(ReplicatedStorage.Shared.UIComponents.UITheme)

local BackgroundFrame = React.Component:extend("BackgroundFrame")

function BackgroundFrame:render()
    return React.createElement("Frame", {
        Size = self.props.Size or UDim2.new(0, 1, 0, 1),
        Position = self.props.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.props.BackgroundColor3 or UITheme.CurrentTheme.BackgroundColor1
    })
end

return BackgroundFrame