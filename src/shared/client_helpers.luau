local client_helpers = {}
local LobbyList = require(script.Parent.UIComponents.LobbyList)
local LobbyEvent = game.ReplicatedStorage.Shared.Remote_Events.LobbyEvent

function client_helpers:doDamage(targetHumanoid, damage)
    targetHumanoid:TakeDamage(damage)
    targetHumanoid = nil
end

function client_helpers:loadLobby(React, root)
    root:render(React.createElement(LobbyList, {}, {}))
    LobbyEvent:FireServer("joined")
end

return client_helpers