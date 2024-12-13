local client_helpers = {}

function client_helpers:doDamage(targetHumanoid, damage)
    targetHumanoid:TakeDamage(damage)
    targetHumanoid = nil
end

return client_helpers