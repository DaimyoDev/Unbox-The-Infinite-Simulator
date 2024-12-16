local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Shared.Packages.react)
local UITheme = require(ReplicatedStorage.Shared.UIComponents.UITheme)

local BasicTextButton = React.Component:extend("BasicTextButton")

function BasicTextButton:init()
    self.state = {
        backgroundColor = self.props.BackgroundColor3 or UITheme.CurrentTheme.BackgroundColor2,
        textColor = self.props.TextColor3 or UITheme.CurrentTheme.TextColor,
        noPadding = self.props.noPadding or false
    }
end

function BasicTextButton:render()
    local paddingElement = nil

    if not self.state.noPadding then
        paddingElement = React.createElement("UIPadding", {
            PaddingTop = UDim.new(0, 10), 
            PaddingBottom = UDim.new(0, 10), 
            PaddingLeft = UDim.new(0, 20), 
            PaddingRight = UDim.new(0, 20)
        })
    end

    return React.createElement("TextButton", {
        Text = self.props.Text or "Button",
        Active = self.props.Active,
        TextColor3 = self.state.textColor,
        TextSize = self.props.TextSize,
        FontFace = self.props.FontFace or Font.fromEnum(Enum.Font.SourceSansBold),
        BackgroundTransparency = self.props.BackgroundTransparency or 0,
        Size = self.props.Size or UDim2.new(0.2, 0, 0.1, 0),
        Position = self.props.Position,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = self.state.backgroundColor,
        TextScaled = self.props.TextScaled,
        BorderSizePixel = self.props.BorderSizePixel or 0,
        [React.Event.Activated] = self.props.OnClick,
        [React.Event.MouseEnter] = function()
            self:setState({
                backgroundColor = self.props.HoverBackgroundColor or UITheme.CurrentTheme.BackgroundColor3,
                textColor = self.props.HoverTextColor or UITheme.CurrentTheme.BackgroundTextColor
            })
        end,
        [React.Event.MouseLeave] = function()
            self:setState({
                backgroundColor = self.props.BackgroundColor3 or UITheme.CurrentTheme.BackgroundColor2,
                textColor = self.props.TextColor3 or UITheme.CurrentTheme.TextColor
            })
        end
    }, {
        React.createElement("UICorner", 
        {
            CornerRadius = UDim.new(0, 20)
        }), paddingElement
    })
end

return BasicTextButton