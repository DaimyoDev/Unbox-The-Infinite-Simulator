local gameFunctions = {}

function gameFunctions:doWeaponDamage(player, weapon, enemyHumanoid)
	--later check if player has actual weapon to prevent exploiters and give them the kill. Have only the player who killed the enemy get the drop.
	if weapon == "Test Gun" then
		enemyHumanoid:TakeDamage(20)
	end
end

function gameFunctions:doEnemyDamage(targetHumanoid, damage)
    targetHumanoid:TakeDamage(damage)
end

function gameFunctions:setPlayerAppearance(player)
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

return gameFunctions