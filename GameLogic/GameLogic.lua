function onLoad()
    addHotkey("Take Damage", function(playerColor) if(playerColor == "Black") then TakeDamage(self.getDescription()) end end)
end

function TakeDamage(colorPlayer)
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Health.current = player.Health.current - 1
    Global.call("SetUI", colorPlayer)
end