local UITheme = {}


UITheme.Themes = {
    {
        BackgroundTextColor = Color3.fromHex("#DAD7CD"),
        TextColor = Color3.fromHex("#344E41"),
        BackgroundColor1 = Color3.fromHex("#344E41"),
        BackgroundColor2 = Color3.fromHex("#DAD7CD"),
        BackgroundColor3 = Color3.fromHex("#588157")
    },
    {
        BackgroundTextColor = Color3.fromHex("#F0EBD8"),
        TextColor = Color3.fromHex("#F0EBD8"),
        BackgroundColor1 = Color3.fromHex("#3E5C76"),
        BackgroundColor2 = Color3.fromHex("#1D2D44"),
        BackgroundColor3 = Color3.fromHex("#0D1321")
    }
}

UITheme.CurrentTheme = UITheme.Themes[1]

return UITheme