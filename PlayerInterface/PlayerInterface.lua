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

-- Apply or remove a buff to/from a character
local function modifyBuff(character, buffType, buffName, value, apply)
    local buffValue = character.buffs[buffType][buffName] or 0
    if apply then
        character.buffs[buffType][buffName] = buffValue + value
    else
        character.buffs[buffType][buffName] = buffValue - value
        if character.buffs[buffType][buffName] <= 0 then
            character.buffs[buffType][buffName] = nil
        end
    end
end

-- Function to apply a buff to a character
local function applyBuff(character, buffType, buffName, value)
    modifyBuff(character, buffType, buffName, value, true)
end

-- Function to remove a buff from a character
local function removeBuff(character, buffType, buffName, value)
    modifyBuff(character, buffType, buffName, value, false)
end

-- Calculate the total buff value for a given buff type and name
local function calculateBuff(character, buffType, buffName)
    if buffType == BUFF_TYPE.SKILL then
        return character.buffs.skills[buffName] or 0
    elseif buffType == BUFF_TYPE.CHARACTERISTIC then
        return character.buffs.characteristics[buffName] or 0
    elseif buffType == BUFF_TYPE.RESISTANCE then
        return character.buffs.resistances[buffName] or 0
    end
    return 0
end

-- Function to apply race buffs
local function applyRaceBuffs(character, raceData)
    for buffName, value in pairs(raceData.skills) do
        applyBuff(character, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(raceData.characteristics) do
        applyBuff(character, BUFF_TYPE.CHARACTERISTIC, buffName, value)
    end
    for buffName, value in pairs(raceData.resistances) do
        applyBuff(character, BUFF_TYPE.RESISTANCE, buffName, value)
    end
end
-- Function to remove race buffs
local function removeRaceBuffs(character, raceData)
    for buffName, value in pairs(raceData.skills) do
        removeBuff(character, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(raceData.characteristics) do
        removeBuff(character, BUFF_TYPE.CHARACTERISTIC, buffName, value)
    end
    for buffName, value in pairs(raceData.resistances) do
        removeBuff(character, BUFF_TYPE.RESISTANCE, buffName, value)
    end
end

-- Function to apply class buffs
local function applyClassBuffs(character, classData)
    for buffName, value in pairs(classData.skills.majorskills) do
        applyBuff(character, BUFF_TYPE.SKILL, buffName, value * 25)
    end
    for buffName, value in pairs(classData.skills.minorskills) do
        applyBuff(character, BUFF_TYPE.SKILL, buffName, value * 10)
    end
    for buffName, value in pairs(classData.characteristics) do
        applyBuff(character, BUFF_TYPE.CHARACTERISTIC, buffName, value * 10)
    end
end
-- Function to remove class buffs
local function removeClassBuffs(character, classData)
    for buffName, value in pairs(classData.skills.majorskills) do
        removeBuff(character, BUFF_TYPE.SKILL, buffName, value * 25)
    end
    for buffName, value in pairs(classData.skills.minorskills) do
        removeBuff(character, BUFF_TYPE.SKILL, buffName, value * 10)
    end
    for buffName, value in pairs(classData.characteristics) do
        removeBuff(character, BUFF_TYPE.CHARACTERISTIC, buffName, value * 10)
    end
end

-- Function to apply sign buffs
local function applySignBuffs(character, signData)
    for buffName, value in pairs(signData.skills) do
        applyBuff(character, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(signData.characteristics) do
        applyBuff(character, BUFF_TYPE.CHARACTERISTIC, buffName, value)
    end
end
-- Function to remove sign buffs
local function removeSignBuffs(character, signData)
    for buffName, value in pairs(signData.skills) do
        removeBuff(character, BUFF_TYPE.SKILL, buffName, value)
    end
    for buffName, value in pairs(signData.characteristics) do
        removeBuff(character, BUFF_TYPE.CHARACTERISTIC, buffName, value)
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

local enumColor = {
    Red = 1, White = 2, Blue = 3
}

local indexVisibilityColorGM = 1
local listColor = {
    "Red", "White", "Blue"
}

-- Default XML information
local procuredXMLForm = {
    tag = "GridLayout",
    attributes = {id = "mainPanel", active = "true", startAxis = "Vertical", padding = "3 3 3 3", spacing = "3 3", cellSize = "230 76", color = "Black"},
    children = {}
}

-- Save information for players
saveInfoPlayer = {
    Red = {}, White = {}, Blue = {}
}

-- Helper function to create a row with name and value
local function createRow(name, value, valueType, nameClass, valueClass, valueTag)
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
                                attributes = { class = nameClass, text = name }
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

-- Helper function to create a table layout with rows
local function createTableLayout(rows)
    return {
        tag = "TableLayout",
        attributes = {image = "TableLayout_Back"},
        children = rows
    }
end

-- Helper function to create a characteristics table layout
local function createCharacteristicsTableLayout(rows)
    return {
        tag = "Row",
        children = {
            {
                tag = "TableLayout",
                attributes = {width = "230", height = "200", offsetXY = "0 -62", image = "TableLayout_Back_Long"},
                children = rows
            }
        }
    }
end

-- Helper function to create a skills table layout
local function createSkillsTableLayout(rows)
    return {
        tag = "Row",
        children = {
            {
                tag = "VerticalScrollView",
                attributes = {width = "230", height = "358", offsetXY = "235 96", image = "TableLayout_Back_Long"},
                children = {
                    {
                        tag = "TableLayout",
                        attributes = {width = "190", height = "825"},
                        children = rows
                    }
                }
            }
        }
    }
end

-- Table to map UI element types to their respective creation functions
local uiElementFunctions = {
    ["progress"] = function(name, value) return createRow(name, value, "progress", "mainInfo", "stateV", "Text") end,
    ["value"] = function(name, value) return createRow(name, value, "value", "mainInfo", "stateV", "Text") end,
    ["info"] = function(name, value) return createRow(name, value, "value", "mainInfo", "infoSkill", "Text") end,
    ["characteristic"] = function(name, value) return createRow(name, value, "value", "gameInfo", "skill", "Button") end,
    ["combatSkill"] = function(name, value) return createRow(name, value, "value", "skillsInfo", "combatSkill", "Button") end,
    ["mageSkill"] = function(name, value) return createRow(name, value, "value", "skillsInfo", "mageSkill", "Button") end,
    ["protectSkill"] = function(name, value) return createRow(name, value, "value", "skillsInfo", "protectSkill", "Button") end,
    ["skill"] = function(name, value) return createRow(name, value, "value", "skillsInfo", "skill", "Button") end
}

-- Create the main XML structure
local function buildXMLStructure()
    local rows = {}
    
    table.insert(rows, createTableLayout({
        uiElementFunctions["progress"]("Health", "health"),
        uiElementFunctions["progress"]("Mana", "mana"),
        uiElementFunctions["progress"]("Stamina", "stamina")
    }))
    table.insert(rows, createTableLayout({
        uiElementFunctions["value"]("Level", "level"),
        uiElementFunctions["value"]("Race", "race"),
        uiElementFunctions["value"]("Class", "class")
    }))
    table.insert(rows, createCharacteristicsTableLayout({
        uiElementFunctions["characteristic"]("Strength", "strength"),
        uiElementFunctions["characteristic"]("Intelligence", "intelligence"),
        uiElementFunctions["characteristic"]("Willpower", "willpower"),
        uiElementFunctions["characteristic"]("Agility", "agility"),
        uiElementFunctions["characteristic"]("Speed", "speed"),
        uiElementFunctions["characteristic"]("Endurance", "endurance"),
        uiElementFunctions["characteristic"]("Personality", "personality"),
        uiElementFunctions["characteristic"]("Luck", "luck")
    }))
    table.insert(rows, createSkillsTableLayout({
        uiElementFunctions["info"]("Major skills", "Major Skills"),
        uiElementFunctions["combatSkill"]("Marksman", "marksman"),
        uiElementFunctions["combatSkill"]("Short Blade", "short_blade"),
        uiElementFunctions["combatSkill"]("Long Blade", "long_blade"),
        uiElementFunctions["combatSkill"]("Axe", "axe"),
        uiElementFunctions["combatSkill"]("Spear", "spear"),
        uiElementFunctions["info"]("Minor skills", "Minor Skills"),
        uiElementFunctions["combatSkill"]("Blunt Weapon", "blunt_weapon"),
        uiElementFunctions["combatSkill"]("Staff", "staff"),
        uiElementFunctions["combatSkill"]("Hand To Hand", "hand_to_hand"),
        uiElementFunctions["protectSkill"]("Medium Armor", "medium_armor"),
        uiElementFunctions["protectSkill"]("Heavy Armor", "heavy_armor"),
        uiElementFunctions["info"]("Misc skills", "Misc Skills"),
        uiElementFunctions["protectSkill"]("Light Armor", "light_armor"),
        uiElementFunctions["protectSkill"]("Block", "block"),
        uiElementFunctions["protectSkill"]("Unarmored", "unarmored"),
        uiElementFunctions["skill"]("Armorer", "armorer"),
        uiElementFunctions["skill"]("Athletics", "athletics"),
        uiElementFunctions["skill"]("Acrobatics", "acrobatics"),
        uiElementFunctions["skill"]("Security", "security"),
        uiElementFunctions["skill"]("Sneak", "sneak"),
        uiElementFunctions["skill"]("Perception", "perception"),
        uiElementFunctions["skill"]("Mercantile", "mercantile"),
        uiElementFunctions["skill"]("Speechcraft", "speechcraft"),
        uiElementFunctions["skill"]("Alchemy", "alchemy"),
        uiElementFunctions["skill"]("Enchant", "enchant"),
        uiElementFunctions["skill"]("Analysis", "analysis"),
        uiElementFunctions["mageSkill"]("Conjuration", "conjuration"),
        uiElementFunctions["mageSkill"]("Illusion", "illusion"),
        uiElementFunctions["mageSkill"]("Restoration", "restoration"),
        uiElementFunctions["mageSkill"]("Mysticism", "mysticism"),
        uiElementFunctions["mageSkill"]("Destruction", "destruction"),
        uiElementFunctions["mageSkill"]("Alteration", "alteration")
    }))

    procuredXMLForm.children = rows
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
        -- Base info
        for i = 1, 2 do
            for j = 1, #newPanel.children[i].children do
                for k = 1, #newPanel.children[i].children[j].children[2].children[1].children do
                    local elementId = newPanel.children[i].children[j].children[2].children[1].children[k].attributes.id
                    newPanel.children[i].children[j].children[2].children[1].children[k].attributes.id = colorPlayer .. elementId
                end
            end
        end
        -- characteristics
        for j = 1, #newPanel.children[3].children[1].children do
            local elementId = newPanel.children[3].children[1].children[j].children[2].children[1].children[1].attributes.id
            newPanel.children[3].children[1].children[j].children[2].children[1].children[1].attributes.id = colorPlayer .. elementId
        end
        -- skills
        for j = 1, #newPanel.children[4].children[1].children[1].children do
            local elementId = newPanel.children[4].children[1].children[1].children[j].children[2].children[1].children[1].attributes.id
            newPanel.children[4].children[1].children[1].children[j].children[2].children[1].children[1].attributes.id = colorPlayer .. elementId
        end

        table.insert(mainPanel, newPanel)
    end

    self.UI.setXmlTable(xmlTable)
end

-- Apply all changes to the character
local function setCharacter(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    changeRaceBonus({colorPlayer, player.race})
    changeClassBonus({colorPlayer, player.class})
    changeSignBonus({colorPlayer, player.sign})
end

-- Function to confer saved data
local function confer()
    isOnLoad = true
    broadcastToAll("[ffee8c]Loading. Please wait.[-]")
    local multiplySleepTime = 3
    for colorPlayer, _ in pairs(saveInfoPlayer) do
        setCharacter(colorPlayer)
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
            self.UI.setAttribute(prevPlayColor, "visibility", prevPlayColor)
        end
        local curPlayColor = listColor[indexVisibilityColorGM] .. "mainPanel"
        self.UI.setAttribute(curPlayColor, "active", "true")
        self.UI.setAttribute(curPlayColor, "visibility", curPlayColor .. "|Black")
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
    --local loadSave = JSON.decode(getObjectFromGUID(SAVE_CUBE_GUID).getGMNotes())
    if loadSave then
        saveInfoPlayer = loadSave
        Wait.time(confer, 1)
    else
        print("Fail to get save. Re-saving.")
        Wait.time(confer, 1)
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
        activateInventory(colorPlayer)
    end)

    WebRequest.get(BASE_INFO_URL, function(request)
        local baseInfo = JSON.decode(request.text)
        if baseInfo then
            for color, _ in pairs(enumColor) do
                saveInfoPlayer[color] = deepCopy(baseInfo)
            end
            buildXMLStructure()
            rebuildXMLTable()
            loadSaveData()
        else
            print("Failed to decode base info.")
        end
    end)

    WebRequest.get(B_WASTE_S_INFO_URL, function(request)
        baseWasteStamina = JSON.decode(request.text)
        if not baseWasteStamina then
            print("Failed to decode base waste stamina.")
        end
    end)
end

-- Function to set UI elements
local seeElement = {health = "", mana = "", stamina = "", level = "", race = "", class = "", characteristics = "", skills = ""}
local function checkSeeElement(name)
    return seeElement[name]
end
function setUI(colorPlayer)
    local state = saveInfoPlayer[colorPlayer]
    for name, value in pairs(state) do
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

    self.UI.setAttribute(colorPlayer .. "HealthPB", "percentage", (state.health.current / state.health.max) * 100)
    self.UI.setAttribute(colorPlayer .. "ManaPB", "percentage", (state.mana.current / state.mana.max) * 100)
    self.UI.setAttribute(colorPlayer .. "StaminaPB", "percentage", (state.stamina.current / state.stamina.max) * 100)
end

local function calculateSkill(player, id)
    return 5 + calculateBuff(player, BUFF_TYPE.SKILL, id) + (player.buffs.classspecialization[id] and 5 or 0)
end
local function calculateCharacteristics(player, id)
    return calculateBuff(player, BUFF_TYPE.CHARACTERISTIC, id)
end
-- Function to calculate player information
function calculateInfo(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    -- Calculate skills
    local xmlTable = self.UI.getXmlTable()
    local skillsTable = xmlTable[2].children[enumColor[colorPlayer]].children[4].children[1].children[1].children
    for index, state in ipairs(skillsTable) do
        local skillId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
        player.skills[skillId] = calculateSkill(player, skillId)
    end
    -- Calculate characteristics
    local characteristicsTable = xmlTable[2].children[enumColor[colorPlayer]].children[3].children[1].children
    for index, state in ipairs(characteristicsTable) do
        local charId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
        player.characteristics[charId] = calculateCharacteristics(player, charId)
    end
    -- Calculate HP
    player.health.max = math.floor((player.characteristics.strength + player.characteristics.endurance) / 2 + (tonumber(player.level) - 1) * (player.characteristics.endurance / 10))
    if player.health.current > player.health.max then player.health.current = player.health.max end
    -- Calculate MP
    player.mana.max = player.characteristics.intelligence * (1 + player.magicbonus.race + player.magicbonus.sign)
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
    player.magicbonus.race = raceData[race].magicbonus or 0
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
    player.buffs.classskills = deepCopy(classData[class].skills)
    player.buffs.classspecialization = deepCopy(specData[classData[class].specialization])
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
        function()
            return flag
        end
    )
end

-- Function to set the player's sign
local function setSignInfo(info, signData)
    local sSign = info[2]
    local player = saveInfoPlayer[info[1]]
    local sign, prevSign = info[2]:lower(), player.sign:lower()
    if(not isOnLoad) then removeSignBuffs(player, signData[prevSign]) end
    applySignBuffs(player, signData[sign])
    player.sign = sSign
    player.buffs.signbuffs = deepCopy(signData[sign].buffs)
    player.abilitys.sign = deepCopy(signData[sign].abilitys)
    player.magicbonus.sign = signData[sign].magicbonus or 0
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
    for skill, _ in pairs(player.buffs.classskills.majorskills) do
        if player.skills[skill] then
            table.insert(sortedSkills, { name = skill, value = player.skills[skill] })
        end
    end

    -- Add minor skills
    table.insert(sortedSkills, { name = "Minor Skills" })
    for skill, _ in pairs(player.buffs.classskills.minorskills) do
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
    local skillsTable = xmlTable[2].children[enumColor[colorPlayer]].children[4].children[1].children[1].children
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
        valueStaminaWaste = baseWasteStamina.run.baseCost + math.random(1, 6)
    elseif id:find("acrobatics") then
        valueStaminaWaste = baseWasteStamina.jump.baseCost
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
    local valueStaminaWaste = baseWasteStamina.cast.baseCost + math.random(2, 5)

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
    local valueStaminaWaste = baseWasteStamina.combat.baseCost + randomStaminaCheck

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
        valueStaminaWaste = baseWasteStamina.block.baseCost + randomStaminaCheck
    else
        -- Calculate the probability of success
        successChance = calculateProtectSuccessChance(
            skillValue, locPlayer.characteristics.agility, locPlayer.characteristics.luck,
            luminary, locPlayer.stamina.current, locPlayer.stamina.max
        )
        valueStaminaWaste = baseWasteStamina.protect.baseCost + randomStaminaCheck
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