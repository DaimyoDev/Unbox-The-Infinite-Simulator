local Enemy = script.Parent
if not script.Parent:IsA("Model") then
    return
end

local legColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
local skinColor = Color3.fromRGB(245, 205, 48)
Enemy.Torso.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
Enemy["Left Leg"].Color, Enemy["Right Leg"].Color = legColor, legColor
Enemy.Head.Color = skinColor
Enemy["Left Arm"].Color = skinColor
Enemy["Right Arm"].Color = skinColor

