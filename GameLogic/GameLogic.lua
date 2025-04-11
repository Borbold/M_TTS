function onLoad()
    colorPlayer = "White"
    addHotkey("Take Damage", function(playerColor) if(playerColor == "Black") then takeDamage() end end)
end

function takeDamage()
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Health.current = player.Health.current - 1
    Global.call("setUI", colorPlayer) Global.call("updateSave")
end

function changeRace(player, race)
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Race = race
    Global.call("changeRaceBonus", colorPlayer) Global.call("setUI", colorPlayer)
end

function changeClass(player, class)
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Class = class
    Global.call("setUI", colorPlayer)
end

function changeColor(player, color)
    colorPlayer = color
end