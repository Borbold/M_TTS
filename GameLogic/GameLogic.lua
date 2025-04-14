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
    local player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Health.current = player.Health.current - 1
    updatePlayer()
end

function changeRace(player, race)
    local player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Race = race
    Global.call("changeRaceBonus", colorPlayer)
    Wait.time(|| reCalculatePlayer(), 0.2)
end

function changeClass(player, class)
    local player = Global.getVar("saveInfoPlayer")[colorPlayer]
    player.Class = class
    Global.call("changeClassBonus", colorPlayer)
    Wait.time(|| Global.call("sortSkillsByImportance", colorPlayer), 0.2)
    Wait.time(|| reCalculatePlayer(), 0.3)
end

function changeColor(player, color)
    colorPlayer = color
end

function fieldEdit(player, value, id)
    self.UI.setAttribute(id, "text", value)
end

function changePlayerState(player, alt, id)
    local player = Global.getVar("saveInfoPlayer")[colorPlayer]
    if(id == "restoreAll") then
        player["Health"].current = player["Health"].max
        player["Mana"].current = player["Mana"].max
        player["Stamina"].current = player["Stamina"].max
    else
        local state = self.UI.getAttribute(id, "text")
        local value = tonumber(self.UI.getAttribute(state, "text")) * (alt == "-1" and 1 or -1)
        player[state].current = player[state].current + value
        player[state].current = player[state].current > player[state].max and player[state].max or player[state].current < 1 and 0 or player[state].current
    end
    updatePlayer()
end