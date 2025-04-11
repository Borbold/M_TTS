function onLoad()
    addHotkey("Take Damage", function(playerColor) if(playerColor == "Black") then takeDamage(self.getDescription()) end end)
end

function takeDamage(colorPlayer)
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Health.current = player.Health.current - 1
    Global.call("setUI", colorPlayer) Global.call("updateSave")
end

function changeRace(player, race)
    local colorPlayer = self.getDescription()
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Race = race
    Global.call("changeRaceBonus", colorPlayer) Global.call("setUI", colorPlayer)
end