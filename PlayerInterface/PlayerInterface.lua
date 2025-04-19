-- Constants for buff types
local BUFF_TYPE = {
    SKILL = "skills",
    CHARACTERISTIC = "characteristics",
    RESISTANCE = "resistances"
}

-- Constants for buff types
local DEBUFF_TYPE = {
    SKILL = "skills",
    CHARACTERISTIC = "characteristics",
    VULNERABILITY = "vulnerabilities"
}

-- Apply or remove a buff to/from a player
local function modifyBuff(player, buffType, buffName, value, apply)
    local buffValue = player.buffs[buffType][buffName] or 0
    if apply then
        player.buffs[buffType][buffName] = buffValue + value
    else
        player.buffs[buffType][buffName] = buffValue - value
        if player.buffs[buffType][buffName] <= 0 then
            player.buffs[buffType][buffName] = nil
        end
    end
end

-- Function to apply a buff to a player
local function applyBuff(player, buffType, buffName, value)
    modifyBuff(player, buffType, buffName, value, true)
end

-- Function to remove a buff from a player
local function removeBuff(player, buffType, buffName, value)
    modifyBuff(player, buffType, buffName, value, false)
end

-- Calculate the total buff value for a given buff type and name
local function calculateBuff(player, buffType, buffName)
    if buffType == BUFF_TYPE.SKILL then
        return player.buffs.skills[buffName] or 0
    elseif buffType == BUFF_TYPE.CHARACTERISTIC then
        return player.buffs.characteristics[buffName] or 0
    elseif buffType == BUFF_TYPE.RESISTANCE then
        return player.buffs.resistances[buffName] or 0
    end
    return 0
end

-- Function to apply race buffs
local function applyRaceBuffs(player, raceData)
    for buffName, value in pairs(raceData.skills) do
        applyBuff(player, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(raceData.characteristics) do
        applyBuff(player, BUFF_TYPE.CHARACTERISTIC, buffName, value)
    end
    for buffName, value in pairs(raceData.resistances) do
        applyBuff(player, BUFF_TYPE.RESISTANCE, buffName, value)
    end
end
-- Function to remove race buffs
local function removeRaceBuffs(player, raceData)
    for buffName, value in pairs(raceData.skills) do
        removeBuff(player, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(raceData.characteristics) do
        removeBuff(player, BUFF_TYPE.CHARACTERISTIC, buffName, value)
    end
    for buffName, value in pairs(raceData.resistances) do
        removeBuff(player, BUFF_TYPE.RESISTANCE, buffName, value)
    end
end

-- Function to apply class buffs
local function applyClassBuffs(player, classData)
    for buffName, value in pairs(classData.skills.majorskills) do
        applyBuff(player, BUFF_TYPE.SKILL, buffName, value * 25)
    end
    for buffName, value in pairs(classData.skills.minorskills) do
        applyBuff(player, BUFF_TYPE.SKILL, buffName, value * 10)
    end
    for buffName, value in pairs(classData.characteristics) do
        applyBuff(player, BUFF_TYPE.CHARACTERISTIC, buffName, value * 10)
    end
end
-- Function to remove class buffs
local function removeClassBuffs(player, classData)
    for buffName, value in pairs(classData.skills.majorskills) do
        removeBuff(player, BUFF_TYPE.SKILL, buffName, value * 25)
    end
    for buffName, value in pairs(classData.skills.minorskills) do
        removeBuff(player, BUFF_TYPE.SKILL, buffName, value * 10)
    end
    for buffName, value in pairs(classData.characteristics) do
        removeBuff(player, BUFF_TYPE.CHARACTERISTIC, buffName, value * 10)
    end
end

-- Function to apply sign buffs
local function applysign_buffs(player, signData)
    for buffName, value in pairs(signData.skills) do
        applyBuff(player, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(signData.characteristics) do
        applyBuff(player, BUFF_TYPE.CHARACTERISTIC, buffName, value)
    end
end
-- Function to remove sign buffs
local function removesign_buffs(player, signData)
    for buffName, value in pairs(signData.skills) do
        removeBuff(player, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(signData.characteristics) do
        removeBuff(player, BUFF_TYPE.CHARACTERISTIC, buffName, value)
    end
end

-- Constants
local SAVE_CUBE_GUID = "f77b1d"
local BASE_INFO_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/BaseInfoPlayer.json"
local RACE_INFO_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/RaceInfo.json"
local CLASS_INFO_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/ClassInfo.json"
local SIGN_INFO_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/SignInfo.json"
local SPEC_INFO_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/SpecializationInfo.json"
local B_WASTE_S_INFO_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/BaseWasteStamina.json"
local TOOLTIP_B_I_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/TooltipBaseInfo.json"
local ITEMS_URL = "https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/Items.json"

local enumColor = {
    Red = 1, White = 2, Blue = 3
}

local indexVisibilityColorGM = 1
local listColor = {
    "Red", "White", "Blue"
}

-- Save information for players
saveInfoPlayer = {
    Red = {}, White = {}, Blue = {}
}

-- Helper function to create a row with item information
local function createItem(name, image, nameClass, tooltip)
    return {
        tag = "Button",
        attributes = { class = nameClass, id = name, tooltip = tooltip, image = image }
    }
end

-- Helper function to create a row with name and value
local function createRow(name, value, valueType, nameClass, valueClass, valueTag, tooltip)
    local valueChildren = valueType == "progress" and {
        {
            tag = "ProgressBar",
            attributes = { id = value .. "PB", class = "statePB", image = "States_Back", fillImage = value .. "_Fill" }
        },
        {
            tag = "Text",
            attributes = { id = value, class = "progressBarV" }
        }
    } or {
        {
            tag = valueTag,
            attributes = { id = value, class = valueClass }
        }
    }

    return {
        tag = "Row",
        children = {
            {
                tag = "Cell",
                attributes = { class = "stateName" },
                children = {
                    {
                        tag = "Row",
                        children = {
                            {
                                tag = "Text",
                                attributes = { class = nameClass, text = name, tooltip = tooltip }
                            }
                        }
                    }
                }
            },
            {
                tag = "Cell",
                attributes = { class = "stateValue" },
                children = {
                    {
                        tag = "Row",
                        children = valueChildren
                    }
                }
            }
        }
    }
end

-- Table to map UI element types to their respective creation functions
local uiElementFunctions = {
    ["progress"] = function(name, value, tooltip) return createRow(name, value, "progress", "mainInfo", "stateV", "Text", tooltip) end,
    ["value"] = function(name, value, tooltip) return createRow(name, value, "value", "mainInfo", "stateV", "Text", tooltip) end,
    ["info"] = function(name, value, tooltip) return createRow(name, value, "value", "mainInfo", "infoSkill", "Text", tooltip) end,
    ["characteristic"] = function(name, value, tooltip) return createRow(name, value, "value", "gameInfo", "skill", "Button", tooltip) end,
    ["combatSkill"] = function(name, value, tooltip) return createRow(name, value, "value", "skillsInfo", "combatSkill", "Button", tooltip) end,
    ["mageSkill"] = function(name, value, tooltip) return createRow(name, value, "value", "skillsInfo", "mageSkill", "Button", tooltip) end,
    ["protectSkill"] = function(name, value, tooltip) return createRow(name, value, "value", "skillsInfo", "protectSkill", "Button", tooltip) end,
    ["skill"] = function(name, value, tooltip) return createRow(name, value, "value", "skillsInfo", "skill", "Button", tooltip) end,
    ["item"] = function(name, image, tooltip) return createItem(name, image, "item", tooltip) end,
}

-- Generate xml and add tooltip
local function generateXML(tooltip)
    procuredXMLForm.children[1].children[3].children[1].children[1].children = {
        uiElementFunctions["progress"]("Health", "health", ""),
        uiElementFunctions["progress"]("Mana", "mana", ""),
        uiElementFunctions["progress"]("Stamina", "stamina", "")
    }
    procuredXMLForm.children[1].children[3].children[1].children[2].children = {
        uiElementFunctions["value"]("Level", "level", ""),
        uiElementFunctions["value"]("Race", "race", ""),
        uiElementFunctions["value"]("Class", "class", "")
    }
    procuredXMLForm.children[1].children[3].children[1].children[3].children[1].children = {
        uiElementFunctions["characteristic"]("Strength", "strength", tooltip.characteristics.strength),
        uiElementFunctions["characteristic"]("Intelligence", "intelligence", tooltip.characteristics.intelligence),
        uiElementFunctions["characteristic"]("Willpower", "willpower", tooltip.characteristics.willpower),
        uiElementFunctions["characteristic"]("Agility", "agility", tooltip.characteristics.agility),
        uiElementFunctions["characteristic"]("Speed", "speed", tooltip.characteristics.speed),
        uiElementFunctions["characteristic"]("Endurance", "endurance", tooltip.characteristics.endurance),
        uiElementFunctions["characteristic"]("Personality", "personality", tooltip.characteristics.personality),
        uiElementFunctions["characteristic"]("Luck", "luck", tooltip.characteristics.luck)
    }
    procuredXMLForm.children[1].children[3].children[1].children[4].children[1].children[1].children = {
        uiElementFunctions["info"]("Major skills", "Major Skills", ""),
        uiElementFunctions["combatSkill"]("Marksman", "marksman", tooltip.skills.marksman),
        uiElementFunctions["combatSkill"]("Short Blade", "short_blade", tooltip.skills.short_blade),
        uiElementFunctions["combatSkill"]("Long Blade", "long_blade", tooltip.skills.long_blade),
        uiElementFunctions["combatSkill"]("Axe", "axe", tooltip.skills.axe),
        uiElementFunctions["combatSkill"]("Spear", "spear", tooltip.skills.spear),
        uiElementFunctions["info"]("Minor skills", "Minor Skills", ""),
        uiElementFunctions["combatSkill"]("Blunt Weapon", "blunt_weapon", tooltip.skills.blunt_weapon),
        uiElementFunctions["combatSkill"]("Staff", "staff", tooltip.skills.staff),
        uiElementFunctions["combatSkill"]("Hand To Hand", "hand_to_hand", tooltip.skills.hand_to_hand),
        uiElementFunctions["protectSkill"]("Medium Armor", "medium_armor", tooltip.skills.medium_armor),
        uiElementFunctions["protectSkill"]("Heavy Armor", "heavy_armor", tooltip.skills.heavy_armor),
        uiElementFunctions["info"]("Misc skills", "Misc Skills", ""),
        uiElementFunctions["protectSkill"]("Light Armor", "light_armor", tooltip.skills.light_armor),
        uiElementFunctions["protectSkill"]("Block", "block", tooltip.skills.block),
        uiElementFunctions["protectSkill"]("Unarmored", "unarmored", tooltip.skills.unarmored),
        uiElementFunctions["skill"]("Armorer", "armorer", tooltip.skills.armorer),
        uiElementFunctions["skill"]("Athletics", "athletics", tooltip.skills.athletics),
        uiElementFunctions["skill"]("Acrobatics", "acrobatics", tooltip.skills.acrobatics),
        uiElementFunctions["skill"]("Security", "security", tooltip.skills.security),
        uiElementFunctions["skill"]("Sneak", "sneak", tooltip.skills.sneak),
        uiElementFunctions["skill"]("Perception", "perception", tooltip.skills.perception),
        uiElementFunctions["skill"]("Mercantile", "mercantile", tooltip.skills.mercantile),
        uiElementFunctions["skill"]("Speechcraft", "speechcraft", tooltip.skills.speechcraft),
        uiElementFunctions["skill"]("Alchemy", "alchemy", tooltip.skills.alchemy),
        uiElementFunctions["skill"]("Enchant", "enchant", tooltip.skills.enchant),
        uiElementFunctions["skill"]("Analysis", "analysis", tooltip.skills.analysis),
        uiElementFunctions["mageSkill"]("Conjuration", "conjuration", tooltip.skills.conjuration),
        uiElementFunctions["mageSkill"]("Illusion", "illusion", tooltip.skills.illusion),
        uiElementFunctions["mageSkill"]("Restoration", "restoration", tooltip.skills.restoration),
        uiElementFunctions["mageSkill"]("Mysticism", "mysticism", tooltip.skills.mysticism),
        uiElementFunctions["mageSkill"]("Destruction", "destruction", tooltip.skills.destruction),
        uiElementFunctions["mageSkill"]("Alteration", "alteration", tooltip.skills.alteration)
    }
end

-- Function to create the main XML structure
local function buildXMLStructure(requestText)
    local xmlTable = self.UI.getXmlTable()
    procuredXMLForm = xmlTable[4]
    local tooltip = JSON.decode(requestText)
    if not tooltip then
        print("Failed to decode tooltip.")
    else
        generateXML(tooltip)
    end
end

-- Function to perform a deep copy of a table
local function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            value = deepCopy(value)
        end
        copy[key] = value
    end
    return copy
end

-- Function to rebuild the XML table
local function rebuildXMLTable()
    local xmlTable = self.UI.getXmlTable()
    local mainPanel = xmlTable[2].children
    for _, colorPlayer in ipairs(listColor) do
        local newPanel = deepCopy(procuredXMLForm)
        newPanel.attributes.id = colorPlayer .. newPanel.attributes.id
        newPanel.attributes.visibility = colorPlayer
        local elementId = ""
        -- See info
        newPanel.children[1].children[1].children[1].children[1].children[1].attributes.id = colorPlayer .. "weight"
        newPanel.children[1].children[1].children[1].children[1].children[2].attributes.id = colorPlayer .. "textWeight"
        -- Base info
        for i = 1, 2 do
            for j = 1, #newPanel.children[1].children[3].children[1].children[i].children do
                for k = 1, #newPanel.children[1].children[3].children[1].children[i].children[j].children[2].children[1].children do
                    elementId = newPanel.children[1].children[3].children[1].children[i].children[j].children[2].children[1].children[k].attributes.id
                    newPanel.children[1].children[3].children[1].children[i].children[j].children[2].children[1].children[k].attributes.id = colorPlayer .. elementId
                end
            end
        end
        -- characteristics
        for j = 1, #newPanel.children[1].children[3].children[1].children[3].children[1].children do
            elementId = newPanel.children[1].children[3].children[1].children[3].children[1].children[j].children[2].children[1].children[1].attributes.id
            newPanel.children[1].children[3].children[1].children[3].children[1].children[j].children[2].children[1].children[1].attributes.id = colorPlayer .. elementId
        end
        -- skills
        for j = 1, #newPanel.children[1].children[3].children[1].children[4].children[1].children[1].children do
            elementId = newPanel.children[1].children[3].children[1].children[4].children[1].children[1].children[j].children[2].children[1].children[1].attributes.id
            newPanel.children[1].children[3].children[1].children[4].children[1].children[1].children[j].children[2].children[1].children[1].attributes.id = colorPlayer .. elementId
        end
        -- items
        for _, item in ipairs(saveInfoPlayer[colorPlayer].items) do
            table.insert(newPanel.children[1].children[2].children[1].children,
                uiElementFunctions["item"](item.name, item.image, item.description))
        end

        table.insert(mainPanel, newPanel)
    end

    self.UI.setXmlTable(xmlTable)
end

-- Update inventory xml form
local function updateItems(colorPlayer)
    local xmlTable, rowItems = self.UI.getXmlTable(), {}
    saveInfoPlayer[colorPlayer].items_weight = 0
    for _, item in ipairs(saveInfoPlayer[colorPlayer].items) do
        table.insert(rowItems, uiElementFunctions["item"](item.name, item.image, item.description))
        saveInfoPlayer[colorPlayer].items_weight = saveInfoPlayer[colorPlayer].items_weight + jsonItems[item.name].weight
    end
    xmlTable[2].children[enumColor[colorPlayer]].children[1].children[2].children[1].children = rowItems
    self.UI.setXmlTable(xmlTable)
    updatePlayer(colorPlayer)
end

-- Picking up an item and transferring it to the inventory
local function takeItem(colorPlayer, object)
    if object and object.hasTag("item") then
        local l1, l2 = '"ImageURL":', '"ImageSecondaryURL"'
        local objJSON = object.getJSON()
        local URLImage = objJSON:sub(objJSON:find(l1) + #l1, objJSON:find(l2) - 1):match([["([^"]+)]])
        local name = object.getName():gsub("%[.-%]","")
        local description = string.format("%s\n%s", name, object.getDescription())
        table.insert(saveInfoPlayer[colorPlayer].items, {name = name, image = URLImage, description = description})
        updateItems(colorPlayer)
    end
end

-- Remove an item from your inventory or use it
function putItem(player, alt, id)
    local colorPlayer = player.color
    local locPlayer = saveInfoPlayer[colorPlayer]
    for i, item in ipairs(locPlayer.items) do
        if item.name == id then
            table.remove(locPlayer.items, i)
            updateItems(colorPlayer)
            return
        end
    end
end

-- Apply all changes to the character
local function setCharacter(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    changeRaceBonus({colorPlayer, player.race})
    changeClassBonus({colorPlayer, player.class})
    changeSignBonus({colorPlayer, player.sign})
end

-- Function to confer saved data
local function confer(isLoad)
    isOnLoad = true
    broadcastToAll("[ffee8c]Loading. Please wait.[-]")
    local multiplySleepTime = 3
    for colorPlayer, _ in pairs(saveInfoPlayer) do
        if not isLoad then setCharacter(colorPlayer) end
        Wait.time(|| sortSkillsByImportance(colorPlayer), (enumColor[colorPlayer] / 3) * multiplySleepTime)
        Wait.time(|| calculateInfo(colorPlayer), (enumColor[colorPlayer] / 2) * multiplySleepTime)
        Wait.time(|| setUI(colorPlayer), (enumColor[colorPlayer]) * multiplySleepTime)
    end
    Wait.time(function() isOnLoad = nil broadcastToAll("[ffee8c]Download is complete.[-]") end, #listColor * multiplySleepTime)
end

-- Function to activate inventory for a player
local function activateInventory(colorPlayer)
    local panelId = colorPlayer .. "mainPanel"
    self.UI.setAttribute(panelId, "active", self.UI.getAttribute(panelId, "active") == "true" and "false" or "true")
end

-- Function to activate inventory for GM
local function activateInventoryForGM()
    if(indexVisibilityColorGM <= #listColor) then
        if(indexVisibilityColorGM > 1) then
            local prevPlayColor = listColor[indexVisibilityColorGM - 1] .. "mainPanel"
            self.UI.setAttribute(prevPlayColor, "visibility", listColor[indexVisibilityColorGM - 1])
        end
        local curPlayColor = listColor[indexVisibilityColorGM] .. "mainPanel"
        self.UI.setAttribute(curPlayColor, "active", "true")
        self.UI.setAttribute(curPlayColor, "visibility", listColor[indexVisibilityColorGM] .. "|Black")
        indexVisibilityColorGM = indexVisibilityColorGM + 1
    else
        for _, color in ipairs(listColor) do
            self.UI.setAttribute(color .. "mainPanel", "visibility", color)
        end
        indexVisibilityColorGM = 1
    end
end

-- Function to load save data
local function loadSaveData()
    local loadSave = JSON.decode(getObjectFromGUID(SAVE_CUBE_GUID).getGMNotes())
    if loadSave then
        saveInfoPlayer = loadSave
        Wait.time(|| confer(true), 1)
    else
        print("Fail to get save. Re-saving.")
        Wait.time(|| confer(false), 1)
        updateSave()
    end
end

-- Function to handle loading and initializing the script
function onLoad()
    addHotkey("Switching all player inventories", function(colorPlayer)
        if colorPlayer == "Black" then
            activateInventoryForGM()
        end
    end)
    addHotkey("Inventory", function(colorPlayer)
        if not isOnLoad then
            activateInventory(colorPlayer)
        end
    end)
    addHotkey("Take item", function(playerColor, object, pointerPosition, isKeyUp)
        if not isOnLoad then
            takeItem(playerColor, object)
        end
    end)

    WebRequest.get(ITEMS_URL, function(request)
        if request.is_done then
            jsonItems = JSON.decode(request.text)
        else
            print("Failed to decode items info.")
        end
    end)

    WebRequest.get(BASE_INFO_URL, function(request)
        if request.is_done then
            local baseInfo = JSON.decode(request.text)
            if baseInfo then
                for color, _ in pairs(enumColor) do
                    saveInfoPlayer[color] = deepCopy(baseInfo)
                end
                local flag = false
                WebRequest.get(TOOLTIP_B_I_URL, function(request)
                    if request.is_done then
                        buildXMLStructure(request.text)
                        flag = true
                    end
                end)
                Wait.condition(function()
                    loadSaveData()
                    rebuildXMLTable()
                end,
                function() return flag end
                )
            else
                print("Failed to decode base info.")
            end
        end
    end)

    WebRequest.get(B_WASTE_S_INFO_URL, function(request)
        if request.is_done then
            baseWasteStamina = JSON.decode(request.text)
            if not baseWasteStamina then
                print("Failed to decode base waste stamina.")
            end
        end
    end)
end

-- Function to set UI elements
local seeElement = {health = "", mana = "", stamina = "", level = "", race = "", class = "", characteristics = "", skills = ""}
local function checkSeeElement(name)
    return seeElement[name]
end
function setUI(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    for name, value in pairs(player) do
        if checkSeeElement(name) then
            if type(value) == "string" then
                self.UI.setAttribute(colorPlayer .. name, "text", value)
            else
                if value.current and value.max then
                    self.UI.setAttribute(colorPlayer .. name, "text", value.current .. "/" .. value.max)
                else
                    for subName, subValue in pairs(value) do
                        self.UI.setAttribute(colorPlayer .. subName, "text", subValue)
                        self.UI.setAttribute(colorPlayer .. subName, "textColor", self.UI.getAttribute(colorPlayer .. subName, "textColor"))
                    end
                end
            end
        end
    end

    self.UI.setAttribute(colorPlayer .. "HealthPB", "percentage", (player.health.current / player.health.max) * 100)
    self.UI.setAttribute(colorPlayer .. "ManaPB", "percentage", (player.mana.current / player.mana.max) * 100)
    self.UI.setAttribute(colorPlayer .. "StaminaPB", "percentage", (player.stamina.current / player.stamina.max) * 100)
    self.UI.setAttribute(colorPlayer .. "textWeight", "text", string.format("%s/%s", player.items_weight, player.characteristics.strength * 5))
    self.UI.setAttribute(colorPlayer .. "weight", "percentage", (player.items_weight / (player.characteristics.strength * 5)) * 100)
end

local function calculateSkill(player, id)
    return 5 + calculateBuff(player, BUFF_TYPE.SKILL, id) + (player.buffs.class_specialization[id] and 5 or 0)
end
local function calculateCharacteristics(player, id)
    return calculateBuff(player, BUFF_TYPE.CHARACTERISTIC, id)
end
-- Function to calculate player information
function calculateInfo(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    -- Calculate skills
    local xmlTable = self.UI.getXmlTable()
    xmlTable = xmlTable[2].children[enumColor[colorPlayer]].children[1].children[3].children[1]
    local skillsTable = xmlTable.children[4].children[1].children[1].children
    for index, state in ipairs(skillsTable) do
        local skillId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
        player.skills[skillId] = calculateSkill(player, skillId)
    end
    -- Calculate characteristics
    local characteristicsTable = xmlTable.children[3].children[1].children
    for index, state in ipairs(characteristicsTable) do
        local charId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
        player.characteristics[charId] = calculateCharacteristics(player, charId)
    end
    -- Calculate HP
    player.health.max = math.floor((player.characteristics.strength + player.characteristics.endurance) / 2 + (tonumber(player.level) - 1) * (player.characteristics.endurance / 10))
    if player.health.current > player.health.max then player.health.current = player.health.max end
    -- Calculate MP
    player.mana.max = player.characteristics.intelligence * (1 + player.magic_bonus.race + player.magic_bonus.sign)
    if player.mana.current > player.mana.max then player.mana.current = player.mana.max end
    -- Calculate SP
    player.stamina.max = player.characteristics.strength + player.characteristics.willpower + player.characteristics.agility + player.characteristics.endurance
    if player.stamina.current > player.stamina.max then player.stamina.current = player.stamina.max end

    updateSave()
end

-- Function to update save data
function updateSave()
    local savedData = JSON.encode(saveInfoPlayer)
    getObjectFromGUID(SAVE_CUBE_GUID).setGMNotes(savedData)
end

-- Function to set the player's race
local function setRaceInfo(info, raceData)
    local rRace = info[2]
    local player = saveInfoPlayer[info[1]]
    local race, prevRace = info[2]:lower(), player.race:lower()
    if(not isOnLoad) then removeRaceBuffs(player, raceData[prevRace]) end
    applyRaceBuffs(player, raceData[race])
    player.race = rRace
    player.magic_bonus.race = raceData[race].magic_bonus or 0
end
-- Function to fetch and set race bonuses
function changeRaceBonus(info)
    WebRequest.get(RACE_INFO_URL, function(request)
        if request.is_done then
            local raceData = JSON.decode(request.text)
            if raceData then
                setRaceInfo(info, raceData)
            else
                print("Failed to decode race data.")
            end
        else
            print("Failed to fetch race information.")
        end
    end)
end

-- Function to set the player's class
local function setClassInfo(info, classData, specData)
    local cClass = info[2]
    local player = saveInfoPlayer[info[1]]
    local class, prevClass = info[2]:lower(), player.class:lower()
    if(not isOnLoad) then removeClassBuffs(player, classData[prevClass]) end
    applyClassBuffs(player, classData[class])
    player.class = cClass
    player.buffs.classs_skills = deepCopy(classData[class].skills)
    player.buffs.class_specialization = deepCopy(specData[classData[class].specialization])
end
-- Function to fetch and set class bonuses
function changeClassBonus(info)
    local specData, flag = {}, false
    WebRequest.get(SPEC_INFO_URL, function(request)
        if request.is_done then
            specData = JSON.decode(request.text)
            if specData then
                flag = true
            else
                print("Failed to decode specialization data.")
            end
        else
            print("Failed to fetch specialization information.")
        end
    end)
    Wait.condition(function()
            WebRequest.get(CLASS_INFO_URL, function(request)
                if request.is_done then
                    local classData = JSON.decode(request.text)
                    if classData then
                        setClassInfo(info, classData, specData)
                    else
                        print("Failed to decode class data.")
                    end
                else
                    print("Failed to fetch class information.")
                end
            end)
        end,
        function() return flag end
    )
end

-- Function to set the player's sign
local function setSignInfo(info, signData)
    local sSign = info[2]
    local player = saveInfoPlayer[info[1]]
    local sign, prevSign = info[2]:lower(), player.sign:lower()
    if(not isOnLoad) then removesign_buffs(player, signData[prevSign]) end
    applysign_buffs(player, signData[sign])
    player.sign = sSign
    player.buffs.sign_buffs = deepCopy(signData[sign].buffs)
    player.abilitys.sign = deepCopy(signData[sign].abilitys)
    player.magic_bonus.sign = signData[sign].magic_bonus or 0
end
-- Function to fetch and set sign bonuses
function changeSignBonus(info)
    WebRequest.get(SIGN_INFO_URL, function(request)
        if request.is_done then
            local signData = JSON.decode(request.text)
            if signData then
                setSignInfo(info, signData)
            else
                print("Failed to decode sign data.")
            end
        else
            print("Failed to fetch sign information.")
        end
    end)
end

local function capitalizeLetter(str)
    local findSecondWord, newWord = str:find("_"), ""
    newWord = str:sub(1, 1):upper() .. str:sub(2)
    if findSecondWord then
        newWord = newWord:sub(1, findSecondWord - 1) .. " " .. newWord:sub(findSecondWord + 1, findSecondWord + 1):upper() .. newWord:sub(findSecondWord + 2)
    end
    return newWord
end
-- Function to sort skills by importance
function sortSkillsByImportance(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    local sortedSkills = {}

    -- Add major skills
    table.insert(sortedSkills, { name = "Major Skills" })
    for skill, _ in pairs(player.buffs.classs_skills.majorskills) do
        if player.skills[skill] then
            table.insert(sortedSkills, { name = skill, value = player.skills[skill] })
        end
    end

    -- Add minor skills
    table.insert(sortedSkills, { name = "Minor Skills" })
    for skill, _ in pairs(player.buffs.classs_skills.minorskills) do
        if player.skills[skill] then
            table.insert(sortedSkills, { name = skill, value = player.skills[skill] })
        end
    end

    -- Add miscellaneous skills
    table.insert(sortedSkills, { name = "Misc Skills" })
    for skill, _ in pairs(player.skills) do
        local flag = true
        for _, v in ipairs(sortedSkills) do
            if v.name == skill then
                flag = false
                break
            end
        end
        if flag then
            table.insert(sortedSkills, { name = skill, value = player.skills[skill] })
        end
    end

    -- Update XML form with sorted skills
    local xmlTable = self.UI.getXmlTable()
    local skillsTable = xmlTable[2].children[enumColor[colorPlayer]].children[1].children[3].children[1].children[4].children[1].children[1].children
    for i, skillEntry in ipairs(sortedSkills) do
        -- Update skill class
        skillsTable[i].children[2].children[1].children[1].attributes.class = self.UI.getAttribute(colorPlayer .. skillEntry.name, "class")
        -- Update skill value id
        skillsTable[i].children[2].children[1].children[1].attributes.id = colorPlayer .. skillEntry.name
        -- Update skill name
        skillsTable[i].children[1].children[1].children[1].attributes.text = capitalizeLetter(skillEntry.name)
    end

    self.UI.setXmlTable(xmlTable)
end

local function wasteStamina(player, colorPlayer, valueChange)
    player.stamina.current = player.stamina.current - valueChange
    player.stamina.current = checkValue({player.stamina.current, player.stamina.max})
    updatePlayer(colorPlayer)
end
-- Function to throw a skill check
function throwSkill(player, alt, id)
    local locPlayer = saveInfoPlayer[player.color]
    local roll = math.random(1, 100)
    local skillValue = tonumber(self.UI.getAttribute(id, "text"))
    print("Dice roll: " .. roll)
    print(roll <= skillValue and "[00ff00]Success[-]" or "[ff0000]Failure[-]")
    local valueStaminaWaste = 0
    if id:find("athletics") then
        -- run or swim
        valueStaminaWaste = baseWasteStamina.run.base_cost + math.random(1, 6)
    elseif id:find("acrobatics") then
        valueStaminaWaste = baseWasteStamina.jump.base_cost
    end
    wasteStamina(locPlayer, player.color, valueStaminaWaste)
end

local function calculateStaminaMod(current, max)
    return 0.75 + (0.5 * current / max)
end
-- Function for calculating the probability of success
local function calculateMageSuccessChance(skill, willpower, luck, magicCost, sound, currentStamina, maxStamina)
    local baseChance = (skill * 2) + (willpower / 5) + (luck / 10) - magicCost - sound
    local successChance = baseChance * calculateStaminaMod(currentStamina, maxStamina)
    return math.floor(successChance)
end
-- Function to throw a skill mage check
function throwMageSkill(player, alt, id)
    local locPlayer = saveInfoPlayer[player.color]
    local skillValue = tonumber(self.UI.getAttribute(id, "text"))
    local sound, magicCost, valueStaminaWaste = 0, 10, 0
    -- Calculate the probability of success
    local successChance = calculateMageSuccessChance(
        skillValue, locPlayer.characteristics.willpower, locPlayer.characteristics.luck,
        magicCost, sound, locPlayer.stamina.current, locPlayer.stamina.max
    )
    print("Probability of success: " .. successChance .. "%")
    local valueStaminaWaste = baseWasteStamina.cast.base_cost + math.random(2, 5)

    -- Generate a random number from 1 to 100
    local roll = math.random(1, 100)
    print("Dice roll: " .. roll)

    -- Checking to see if the cast is successful
    print(roll <= successChance and "[00ff00]Success[-]" or "[ff0000]Failure[-]")
    wasteStamina(locPlayer, player.color, valueStaminaWaste)
end

-- Function for calculating the probability of success
local function calculateCombatSuccessChance(skill, agility, luck, blind, currentStamina, maxStamina)
    local baseChance = skill + (agility / 5) + (luck / 10) - blind
    local successChance = baseChance * calculateStaminaMod(currentStamina, maxStamina)
    return math.floor(successChance)
end
-- Function to throw a skill combat check
function throwCombatSkill(player, alt, id)
    local locPlayer = saveInfoPlayer[player.color]
    local skillValue = tonumber(self.UI.getAttribute(id, "text"))
    local blind, valueStaminaWaste = 0, 0
    local randomStaminaCheck = math.random(2, 5)
    -- Calculate the probability of success
    local successChance = calculateCombatSuccessChance(
        skillValue, locPlayer.characteristics.agility, locPlayer.characteristics.luck,
        blind, locPlayer.stamina.current, locPlayer.stamina.max
    )
    print("Probability of success: " .. successChance .. "%")
    local valueStaminaWaste = baseWasteStamina.combat.base_cost + randomStaminaCheck

    -- Generate a random number from 1 to 100
    local roll = math.random(1, 100)
    print("Dice roll: " .. roll)

    -- Checking to see if the cast is successful
    --print(roll <= successChance and "[00ff00]Success[-]" or "[ff0000]Failure[-]")
    wasteStamina(locPlayer, player.color, valueStaminaWaste)
end

-- Function for calculating the probability of success
local function calculateBlockSuccessChance(skill, agility, luck, currentStamina, maxStamina)
    local baseChance = (skill + agility / 5 + luck / 10) * ((math.random(1, 10) / 10) * 1 + 1) -- +25% if don't move
    local successChance = baseChance * calculateStaminaMod(currentStamina, maxStamina)
    return math.floor(successChance)
end
-- Function for calculating the probability of success
local function calculateProtectSuccessChance(skill, agility, luck, luminary, currentStamina, maxStamina)
    local baseChance = (agility / 5 + luck / 10) + luminary
    local successChance = baseChance * calculateStaminaMod(currentStamina, maxStamina)
    return math.floor(successChance)
end
-- Function to throw a skill defense check
function throwProtectSkill(player, alt, id)
    local locPlayer = saveInfoPlayer[player.color]
    local skillValue = tonumber(self.UI.getAttribute(id, "text"))
    local luminary, successChance, valueStaminaWaste = 0, 0, 0
    local randomStaminaCheck = math.random(2, 5)
    if(id:find("block")) then
        -- Calculate the probability of success
        successChance = calculateBlockSuccessChance(
            skillValue, locPlayer.characteristics.agility, locPlayer.characteristics.luck,
            locPlayer.stamina.current, locPlayer.stamina.max
        )
        successChance = successChance > 50 and 50 or successChance < 10 and 10 or successChance
        valueStaminaWaste = baseWasteStamina.block.base_cost + randomStaminaCheck
    else
        -- Calculate the probability of success
        successChance = calculateProtectSuccessChance(
            skillValue, locPlayer.characteristics.agility, locPlayer.characteristics.luck,
            luminary, locPlayer.stamina.current, locPlayer.stamina.max
        )
        valueStaminaWaste = baseWasteStamina.protect.base_cost + randomStaminaCheck
    end
    print("Probability of success: " .. successChance .. "%")

    -- Generate a random number from 1 to 100
    local roll = math.random(1, 100)
    print("Dice roll: " .. roll)

    -- Checking to see if the cast is successful
    --print(roll <= successChance and "[00ff00]Success[-]" or "[ff0000]Failure[-]")
    wasteStamina(locPlayer, player.color, valueStaminaWaste)
end

-- Use in GameLogic --
-- Update player data
function updatePlayer(colorPlayer)
    setUI(colorPlayer) updateSave()
end
-- Check for exceeding limits
function checkValue(state)
    return state[1] > state[2] and state[2] or state[1] < 1 and 0 or state[1]
end
-- Use in GameLogic --