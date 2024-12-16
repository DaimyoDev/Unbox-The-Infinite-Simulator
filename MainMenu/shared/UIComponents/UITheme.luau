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
    },
    {
        BackgroundTextColor = Color3.fromHex("#FED0BB"),
        TextColor = Color3.fromHex("#FED0BB"),
        BackgroundColor1 = Color3.fromHex("#B23A48"),
        BackgroundColor2 = Color3.fromHex("#8C2F39"),
        BackgroundColor3 = Color3.fromHex("#461220")
    },
    {
        BackgroundTextColor = Color3.fromHex("#EB5E28"),
        TextColor = Color3.fromHex("#EB5E28"),
        BackgroundColor1 = Color3.fromHex("#252422"),
        BackgroundColor2 = Color3.fromHex("#403D39"),
        BackgroundColor3 = Color3.fromHex("#FFFCF2")
    },
    {
        BackgroundTextColor = Color3.fromHex("#FDC500"),
        TextColor = Color3.fromHex("#FDC500"),
        BackgroundColor1 = Color3.fromHex("#00509D"),
        BackgroundColor2 = Color3.fromHex("#003F88"),
        BackgroundColor3 = Color3.fromHex("#00296B")
    },
    {
        BackgroundTextColor = Color3.fromHex("#AB8476"),
        TextColor = Color3.fromHex("#AB8476"),
        BackgroundColor1 = Color3.fromHex("#1A1423"),
        BackgroundColor2 = Color3.fromHex("#3D314A"),
        BackgroundColor3 = Color3.fromHex("#684756")
    },
    {
        BackgroundTextColor = Color3.fromHex("#F1E1C7"),
        TextColor = Color3.fromHex("#282225"),
        BackgroundColor1 = Color3.fromHex("#733A2F"),
        BackgroundColor2 = Color3.fromHex("#BD6644"),
        BackgroundColor3 = Color3.fromHex("#82877E")
    },
    {
        BackgroundTextColor = Color3.fromHex("#FFFFFF"),
        TextColor = Color3.fromHex("#FFFFFF"),
        BackgroundColor1 = Color3.fromHex("#226F54"),
        BackgroundColor2 = Color3.fromHex("#DA2C38"),
        BackgroundColor3 = Color3.fromHex("#43291F")
    },
    {
        BackgroundTextColor = Color3.fromHex("#EDF2F4"),
        TextColor = Color3.fromHex("#EDF2F4"),
        BackgroundColor1 = Color3.fromHex("#2B2D42"),
        BackgroundColor2 = Color3.fromHex("#EF233C"),
        BackgroundColor3 = Color3.fromHex("#EF233C")
    },
    {
        BackgroundTextColor = Color3.fromHex("#FEFAE0"),
        TextColor = Color3.fromHex("#FEFAE0"),
        BackgroundColor1 = Color3.fromHex("#283618"),
        BackgroundColor2 = Color3.fromHex("#606C38"),
        BackgroundColor3 = Color3.fromHex("#606C38")
    },
    {
        BackgroundTextColor = Color3.fromHex("#FBFEF9"),
        TextColor = Color3.fromHex("#FBFEF9"),
        BackgroundColor1 = Color3.fromHex("#0E79B2"),
        BackgroundColor2 = Color3.fromHex("#191923"),
        BackgroundColor3 = Color3.fromHex("#191923")
    },
    {
        BackgroundTextColor = Color3.fromHex("#B8D8D8"),
        TextColor = Color3.fromHex("#B8D8D8"),
        BackgroundColor1 = Color3.fromHex("#7A9E9F"),
        BackgroundColor2 = Color3.fromHex("#4F6367"),
        BackgroundColor3 = Color3.fromHex("#4F6367")
    },
    {
        BackgroundTextColor = Color3.fromHex("#EDEBD7"),
        TextColor = Color3.fromHex("#423E37"),
        BackgroundColor1 = Color3.fromHex("#423E37"),
        BackgroundColor2 = Color3.fromHex("#E3B23C"),
        BackgroundColor3 = Color3.fromHex("#423E37")
    }
}

UITheme.CurrentTheme = UITheme.Themes[math.random(1, #UITheme.Themes)]

return UITheme