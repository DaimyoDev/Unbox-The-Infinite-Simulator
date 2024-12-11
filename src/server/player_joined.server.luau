local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayButtonClicked = ReplicatedStorage.Shared.Remote_Events.PlayButtonClicked
Players.CharacterAutoLoads = false --Make sure this is for the main menu only.I can check to see if the player died. If not then Autoload will be on.

PlayButtonClicked.OnServerEvent:Connect(function(player)
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
end)