local function changeStatePlayer(playerColor, state, alt)
    if playerColor ~= "Black" then return end
    local player = Global.getVar("saveInfoPlayer")[selectedColorPlayer]
    local value = tonumber(self.UI.getAttribute(state, "text")) * (alt == nil and 1 or -1)
    player[state].current = player[state].current + value
    player[state].current = Global.call("checkValue", {player[state].current, player[state].max})
    Global.call("updatePlayer", selectedColorPlayer)
end
local function addStateChangeHotkey(name, state)
    addHotkey(name, function(playerColor, object, pointerPosition, isKeyUp)
        changeStatePlayer(playerColor, state, object)
    end)
end

-- Stamina regeneration function after each move
local function restoreStaminaPerTurn(playerColor)
    if playerColor ~= "Black" then return end
    local indexSleep = 0.1
    for colorPlayer, player in pairs(Global.getVar("saveInfoPlayer")) do
        player.stamina.current = player.stamina.current + math.floor(2.5 + (0.02 * player.characteristics.endurance))
        player.stamina.current = Global.call("checkValue", {player.stamina.current, player.stamina.max})
        Wait.time(|| Global.call("updatePlayer", colorPlayer), indexSleep)
        indexSleep = indexSleep + 0.1
    end
end

function onLoad()
    bodyHitTable = {
        chest = 30, shoulder = 20, legs = 15, arm = 20, feets = 10, head = 5
    }
    selectedColorPlayer = "White"
    addStateChangeHotkey("Change player HP", "health")
    addStateChangeHotkey("Change player MP", "mana")
    addStateChangeHotkey("Change player SP", "stamina")
    addHotkey("Restore Stamina Per Turn", function(playerColor, object, pointerPosition, isKeyUp) restoreStaminaPerTurn(playerColor) end)
end

-- Update the player's basic information
local function reCalculatePlayer()
    Global.call("sortSkillsByImportance", selectedColorPlayer) Global.call("calculateInfo", selectedColorPlayer) Global.call("updatePlayer", selectedColorPlayer)
end

function changeRace(player, race)
    Global.call("changeRaceBonus", {selectedColorPlayer, race})
    Wait.time(|| reCalculatePlayer(), 0.2)
end

function changeClass(player, class)
    Global.call("changeClassBonus", {selectedColorPlayer, class})
    Wait.time(|| reCalculatePlayer(), 0.3)
end

function changeSign(player, sign)
    Global.call("changeSignBonus", {selectedColorPlayer, sign})
    Wait.time(|| reCalculatePlayer(), 0.3)
end

function changeColor(player, color)
    selectedColorPlayer = color
end

-- That's the way to do it. TTS does not know how to write text to InputField text by itself.
function fieldEdit(player, value, id)
    self.UI.setAttribute(id, "text", value)
end

-- Restore all statistical parameters to maximum
local function restoreAll(player)
    player.health.current = player.health.max
    player.mana.current = player.mana.max
    player.stamina.current = player.stamina.max
end

function changePlayerState(player, alt, id)
    local player = Global.getVar("saveInfoPlayer")[selectedColorPlayer]
    if(id == "restoreAll") then
        restoreAll(player)
    elseif(id == "restoreStaminaPerTurn") then
        restoreStaminaPerTurn()
    else
        local state = self.UI.getAttribute(id, "text"):lower()
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