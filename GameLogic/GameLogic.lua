function onLoad()
    colorPlayer = "White"
    addHotkey("Take Damage", function(playerColor) if(playerColor == "Black") then takeDamage() end end)
end

local function updatePlayer()
    Global.call("setUI", colorPlayer) Global.call("updateSave")
end
local function reCalculatePlayer()
    Global.call("calculateInfo", colorPlayer) updatePlayer()
end

function takeDamage()
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Health.current = player.Health.current - 1
    updatePlayer()
end

function changeRace(player, race)
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Race = race
    Global.call("changeRaceBonus", colorPlayer)
    Wait.time(|| reCalculatePlayer(), 0.2)
end

function changeClass(player, class)
    local player = {} player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Class = class
    Global.call("changeClassBonus", colorPlayer)
    Wait.time(|| Global.call("sortSkillsByImportance", colorPlayer), 0.2)
    Wait.time(|| reCalculatePlayer(), 0.3)
end

function changeColor(player, color)
    colorPlayer = color
end