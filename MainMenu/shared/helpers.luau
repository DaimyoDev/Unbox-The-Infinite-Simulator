local helpers = {}

function helpers:respawnPlayer(player)
    player:LoadCharacter()
end

function helpers:setPlayerAppearance(player)
    local legColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    local skinColor = Color3.fromRGB(245, 205, 48)
    player:LoadCharacter()
    player.Character.Torso.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    player.Character.Head.Color = skinColor
    player.Character["Left Arm"].Color = skinColor
    player.Character["Right Arm"].Color = skinColor
    player.Character["Left Leg"].Color, player.Character["Right Leg"].Color = legColor, legColor
    legColor = nil
    skinColor = nil
end

return helpers