local function changeStatePlayer(playerColor, state, alt)
    if(not playerColor == "Black") then return end
    local player = Global.getVar("saveInfoPlayer")[selectedColorPlayer]
    local value = tonumber(self.UI.getAttribute(state, "text")) * (alt == nil and 1 or -1)
    player[state].current = player[state].current + value
    player[state].current = Global.call("checkValue", {player[state].current, player[state].max})
    Global.call("updatePlayer", selectedColorPlayer)
end

function onLoad()
    bodyHitTable = {
        chest = 30, shoulder = 20, legs = 15, arm = 20, feets = 10, head = 5
    }
    selectedColorPlayer = "White"
    addHotkey("Change player HP", function(playerColor, object, pointerPosition, isKeyUp) changeStatePlayer(playerColor, "Health", object) end)
    addHotkey("Change player MP", function(playerColor, object, pointerPosition, isKeyUp) changeStatePlayer(playerColor, "Mana", object) end)
    addHotkey("Change player SP", function(playerColor, object, pointerPosition, isKeyUp) changeStatePlayer(playerColor, "Stamina", object) end)
end

local function reCalculatePlayer()
    Global.call("calculateInfo", selectedColorPlayer) Global.call("updatePlayer", selectedColorPlayer)
end

function changeRace(player, race)
    local player = Global.getVar("saveInfoPlayer")[selectedColorPlayer]
    player.Race = race
    Global.call("changeRaceBonus", selectedColorPlayer)
    Wait.time(|| reCalculatePlayer(), 0.2)
end

function changeClass(player, class)
    local player = Global.getVar("saveInfoPlayer")[selectedColorPlayer]
    player.Class = class
    Global.call("changeClassBonus", selectedColorPlayer)
    Wait.time(|| Global.call("sortSkillsByImportance", selectedColorPlayer), 0.2)
    Wait.time(|| reCalculatePlayer(), 0.3)
end

function changeSign(player, sign)
    local player = Global.getVar("saveInfoPlayer")[selectedColorPlayer]
    player.Sign = sign
    Global.call("changeSignBonus", selectedColorPlayer)
    Wait.time(|| Global.call("sortSkillsByImportance", selectedColorPlayer), 0.2)
    Wait.time(|| reCalculatePlayer(), 0.3)
end

function changeColor(player, color)
    selectedColorPlayer = color
end

function fieldEdit(player, value, id)
    self.UI.setAttribute(id, "text", value)
end

-- Restore all statistical parameters to maximum
local function restoreAll(player)
    player.Health.current = player.Health.max
    player.Mana.current = player.Mana.max
    player.Stamina.current = player.Stamina.max
end
-- Stamina regeneration function after each move
local function restoreStaminaPerTurn()
    local indexSleep = 0.1
    for colorPlayer, player in pairs(Global.getVar("saveInfoPlayer")) do
        player.Stamina.current = player.Stamina.current + math.floor(2.5 + (0.02 * player.Characteristics.Endurance))
        player.Stamina.current = Global.call("checkValue", {player.Stamina.current, player.Stamina.max})
        Wait.time(|| Global.call("updatePlayer", colorPlayer), indexSleep)
        indexSleep = indexSleep + 0.1
    end
end
function changePlayerState(player, alt, id)
    local player = Global.getVar("saveInfoPlayer")[selectedColorPlayer]
    if(id == "restoreAll") then
        restoreAll(player)
    elseif(id == "restoreStaminaPerTurn") then
        restoreStaminaPerTurn()
    else
        local state = self.UI.getAttribute(id, "text")
        local value = tonumber(self.UI.getAttribute(state, "text")) * (alt == "-1" and 1 or -1)
        player[state].current = player[state].current + value
        player[state].current = Global.call("checkValue", {player[state].current, player[state].max})
    end
    Global.call("updatePlayer", selectedColorPlayer)
end

function whatPartBodyHit()
    local roll = math.random(1, 100)
    local cumulativeProbability = 0
    for bodyPart, probability in pairs(bodyHitTable) do
        cumulativeProbability = cumulativeProbability + probability
        if roll <= cumulativeProbability then
            if(bodyPart == "chest" or bodyPart == "head") then
                print("The impact came on: " .. bodyPart)
            else
                local whatBP = string.format("%s %s", math.random(1, 2) == 1 and "left" or "right", bodyPart)
                print("The impact came on: " .. whatBP)
            end
            return
        end
    end
end