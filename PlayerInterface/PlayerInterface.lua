-- XML --
-- Default XML information
local procuredXMLForm = {
    tag = "GridLayout",
    attributes = {id = "mainPanel", active = "true", startAxis = "Vertical", padding = "3 3 3 3", spacing = "3 3", cellSize = "230 66", color = "Black"},
    children = {}
}

-- Helper function to create a row with name and value
local function createRow(name, value, valueType, nameClass, valueClass, valueTag)
    local valueChildren = valueType == "progress" and {
        {
            tag = "ProgressBar",
            attributes = {id = value .. "PB", class = "statePB", image = "States_Back", fillImage = value .. "_Fill"}
        },
        {
            tag = "Text",
            attributes = {id = value, class = "progressBarV"}
        }
    } or {
        {
            tag = valueTag,
            attributes = {id = value, class = valueClass}
        }
    }

    return {
        tag = "Row",
        children = {
            {
                tag = "Cell",
                attributes = {class = "stateName"},
                children = {
                    {
                        tag = "Row",
                        children = {
                            {
                                tag = "Text",
                                attributes = {class = nameClass, text = name}
                            }
                        }
                    }
                }
            },
            {
                tag = "Cell",
                attributes = {class = "stateValue"},
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
        attributes = {width = "230", height = "66", image = "TableLayout_Back"},
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
                attributes = {width = "230", height = "175", offsetXY = "0 -55", image = "TableLayout_Back_Long"},
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
                attributes = {width = "230", height = "313", offsetXY = "235 84", image = "TableLayout_Back_Long"},
                children = {
                    {
                        tag = "TableLayout",
                        attributes = {width = "190", height = "664"},
                        children = rows
                    }
                }
            }
        }
    }
end

-- Create the main XML structure
procuredXMLForm.children = {
    createTableLayout({
        createRow("Health", "Health", "progress", "mainInfo", "stateV", "Text"),
        createRow("Mana", "Mana", "progress", "mainInfo", "stateV", "Text"),
        createRow("Stamina", "Stamina", "progress", "mainInfo", "stateV", "Text")
    }),
    createTableLayout({
        createRow("Level", "Level", "value", "mainInfo", "stateV", "Text"),
        createRow("Race", "Race", "value", "mainInfo", "stateV", "Text"),
        createRow("Class", "Class", "value", "mainInfo", "stateV", "Text")
    }),
    createCharacteristicsTableLayout({
        createRow("Strength", "Strength", "value", "gameInfo", "stateV", "Button"),
        createRow("Intelligence", "Intelligence", "value", "gameInfo", "stateV", "Button"),
        createRow("Willpower", "Willpower", "value", "gameInfo", "stateV", "Button"),
        createRow("Agility", "Agility", "value", "gameInfo", "stateV", "Button"),
        createRow("Speed", "Speed", "value", "gameInfo", "stateV", "Button"),
        createRow("Endurance", "Endurance", "value", "gameInfo", "stateV", "Button"),
        createRow("Personality", "Personality", "value", "gameInfo", "stateV", "Button"),
        createRow("Luck", "Luck", "value", "gameInfo", "stateV", "Button")
    }),
    createSkillsTableLayout({
        createRow("Major Skills", "MajorSkills", "value", "mainInfo", "infoSkill", "Text"),
        createRow("Long Blade", "LongBlade", "value", "skillsInfo", "stateV", "Button"),
        createRow("Axe", "Axe", "value", "skillsInfo", "stateV", "Button"),
        createRow("Blunt Weapon", "BluntWeapon", "value", "skillsInfo", "stateV", "Button"),
        createRow("Armorer", "Armorer", "value", "skillsInfo", "stateV", "Button"),
        createRow("Medium Armor", "MediumArmor", "value", "skillsInfo", "stateV", "Button"),
        createRow("Minor Skills", "MinorSkills", "value", "mainInfo", "infoSkill", "Text"),
        createRow("Heavy Armor", "HeavyArmor", "value", "skillsInfo", "stateV", "Button"),
        createRow("Spear", "Spear", "value", "skillsInfo", "stateV", "Button"),
        createRow("Block", "Block", "value", "skillsInfo", "stateV", "Button"),
        createRow("Athletics", "Athletics", "value", "skillsInfo", "stateV", "Button"),
        createRow("Alchemy", "Alchemy", "value", "skillsInfo", "stateV", "Button"),
        createRow("Misc Skills", "MiscSkills", "value", "mainInfo", "infoSkill", "Text"),
        createRow("Enchant", "Enchant", "value", "skillsInfo", "stateV", "Button"),
        createRow("Conjuration", "Conjuration", "value", "skillsInfo", "stateV", "Button"),
        createRow("Alteration", "Alteration", "value", "skillsInfo", "stateV", "Button"),
        createRow("Destruction", "Destruction", "value", "skillsInfo", "stateV", "Button"),
        createRow("Mysticism", "Mysticism", "value", "skillsInfo", "stateV", "Button"),
        createRow("Restoration", "Restoration", "value", "skillsInfo", "stateV", "Button"),
        createRow("Illusion", "Illusion", "value", "skillsInfo", "stateV", "Button"),
        createRow("Unarmored", "Unarmored", "value", "skillsInfo", "stateV", "Button"),
        createRow("Acrobatics", "Acrobatics", "value", "skillsInfo", "stateV", "Button"),
        createRow("Security", "Security", "value", "skillsInfo", "stateV", "Button"),
        createRow("Sneak", "Sneak", "value", "skillsInfo", "stateV", "Button"),
        createRow("Light Armor", "LightArmor", "value", "skillsInfo", "stateV", "Button"),
        createRow("Marksman", "Marksman", "value", "skillsInfo", "stateV", "Button"),
        createRow("Short Blade", "ShortBlade", "value", "skillsInfo", "stateV", "Button"),
        createRow("Hand to Hand", "HandToHand", "value", "skillsInfo", "stateV", "Button"),
        createRow("Mercantile", "Mercantile", "value", "skillsInfo", "stateV", "Button"),
        createRow("Speechcraft", "Speechcraft", "value", "skillsInfo", "stateV", "Button")
    })
}
-- XML --
-----------------------------------------------------------------
-- Save information for players
saveInfoPlayer = {
    Red = {}, White = {}, Blue = {}
}
-- f77b1d - Guid save cube
local saveCube = "f77b1d"

local enumColor = {
    Red = 1, White = 2, Blue = 3
}

local indexVisibilityColorGM = 1
local listColor = {
    "Red", "White", "Blue"
}
-----------------------------------------------------------------
-- Local functions --
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
        -- Characteristics
        for j = 1, #newPanel.children[3].children[1].children do
            local elementId = newPanel.children[3].children[1].children[j].children[2].children[1].children[1].attributes.id
            newPanel.children[3].children[1].children[j].children[2].children[1].children[1].attributes.id = colorPlayer .. elementId
        end
        -- Skills
        for j = 1, #newPanel.children[4].children[1].children[1].children do
            local elementId = newPanel.children[4].children[1].children[1].children[j].children[2].children[1].children[1].attributes.id
            newPanel.children[4].children[1].children[1].children[j].children[2].children[1].children[1].attributes.id = colorPlayer .. elementId
        end

        table.insert(mainPanel, newPanel)
    end

    self.UI.setXmlTable(xmlTable)
end

-- Apply all changes to the character
local function setCharacter(playerColor)
    changeRaceBonus(playerColor) changeClassBonus(playerColor) changeSignBonus(playerColor)
end

-- Function to confer saved data
local function confer()
    broadcastToAll("[ffee8c]Loading. Please wait.[-]")
    local multiplySleepTime = 3
    for playerColor, _ in pairs(saveInfoPlayer) do
        setCharacter(playerColor)
        Wait.time(|| sortSkillsByImportance(playerColor), (enumColor[playerColor] / 3) * multiplySleepTime)
        Wait.time(|| calculateInfo(playerColor), (enumColor[playerColor] / 2) * multiplySleepTime)
        Wait.time(|| setUI(playerColor), (enumColor[playerColor]) * multiplySleepTime)
    end
    Wait.time(|| broadcastToAll("[ffee8c]Download is complete.[-]"), #listColor * multiplySleepTime)
end

-- Function to activate inventory for a player
local function activateInventory(playerColor)
    local panelId = playerColor .. "mainPanel"
    self.UI.setAttribute(panelId, "active", self.UI.getAttribute(panelId, "active") == "true" and "false" or "true")
end

-- Function to activate inventory for GM
local function activateInventoryForGM(playerColor)
    if playerColor then
        local currentPanelId = playerColor .. "mainPanel"
        local previousPanelId = listColor[indexVisibilityColorGM > 1 and indexVisibilityColorGM - 1 or 1] .. "mainPanel"
        self.UI.setAttribute(currentPanelId, "active", "true")
        self.UI.setAttribute(previousPanelId, "visibility", playerColor)
        self.UI.setAttribute(currentPanelId, "visibility", playerColor .. "|Black")
    end

    indexVisibilityColorGM = indexVisibilityColorGM + 1
    if indexVisibilityColorGM > #listColor + 1 then
        self.UI.setAttribute(listColor[#listColor] .. "mainPanel", "visibility", listColor[#listColor])
        indexVisibilityColorGM = 1
    end
end

-- Function to handle loading and initializing the script
function onLoad()
    addHotkey("GM Inventory", function(playerColor)
        if playerColor == "Black" then
            activateInventoryForGM(listColor[indexVisibilityColorGM])
        end
    end)
    addHotkey("Player Inventory", function(playerColor)
        activateInventory(playerColor)
    end)

    local baseInfoPlayer = {}
    WebRequest.get("https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/BaseInfoPlayer.json",
        function(request)
            for color, _ in pairs(enumColor) do
                saveInfoPlayer[color] = deepCopy(JSON.decode(request.text))
            end
        end
    )

    Wait.time(function()
        rebuildXMLTable()
        local loadSave = JSON.decode(getObjectFromGUID(saveCube).getGMNotes())
        if loadSave then
            saveInfoPlayer = loadSave
            Wait.time(function() confer() end, 1)
        else
            print("Fail to get save. Re-saving.")
            Wait.time(function() confer() end, 1)
            updateSave()
        end
    end, 1)
end
-- Local functions --
-----------------------------------------------------------------
-- Global functions --
-- Function to set UI elements
local seeElement = {Health = "", Mana = "", Stamina = "", Level = "", Race = "", Class = "", Characteristics = "", Skills = ""}
local function checkSeeElement(name)
    return seeElement[name]
end
function setUI(colorPlayer)
    local state = saveInfoPlayer[colorPlayer]
    for name, value in pairs(state) do
        if(checkSeeElement(name)) then
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

    self.UI.setAttribute(colorPlayer .. "HealthPB", "percentage", (state.Health.current / state.Health.max) * 100)
    self.UI.setAttribute(colorPlayer .. "ManaPB", "percentage", (state.Mana.current / state.Mana.max) * 100)
    self.UI.setAttribute(colorPlayer .. "StaminaPB", "percentage", (state.Stamina.current / state.Stamina.max) * 100)
end

-- Function to throw a skill check
function throwSkill(player, alt, id)
    local rollValue = math.random(1, 100)
    local skillValue = tonumber(self.UI.getAttribute(id, "text"))
    print(rollValue <= skillValue and "[00ff00]Success[-]" or "[ff0000]Failure[-]")
end

local function checkClassSkillsBonus(classSkills, skillId)
    return classSkills.majorSkills[skillId] or classSkills.minorSkills[skillId] or 5
end
-- Function to calculate player information
function calculateInfo(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    --Calculate skills
    local xmlTable = self.UI.getXmlTable()
    local skillsTable = xmlTable[2].children[enumColor[colorPlayer]].children[4].children[1].children[1].children
    for index, state in ipairs(skillsTable) do
        local skillId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
        player.Skills[skillId] = (player.Buffs.RaceSkills[skillId] or 0) + checkClassSkillsBonus(player.Buffs.ClassSkills, skillId)
    end
    -- Calculate characteristics
    local characteristicsTable = xmlTable[2].children[enumColor[colorPlayer]].children[3].children[1].children
    for index, state in ipairs(characteristicsTable) do
        local charId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
        player.Characteristics[charId] = (player.Buffs.RaceCharacteristics[charId] or 0) + (player.Buffs.ClassCharacteristics[charId] or 0)
    end
    -- Calculate HP
    player.Health.max = (player.Characteristics.Strength + player.Characteristics.Endurance) / 2 + (tonumber(player.Level) - 1) * (player.Characteristics.Endurance / 10)
    if player.Health.current > player.Health.max then player.Health.current = player.Health.max end
    -- Calculate MP
    player.Mana.max = player.Characteristics.Intelligence * (1 + player.MagicBonus --[[ Birth sign modifier ]])
    if player.Mana.current > player.Mana.max then player.Mana.current = player.Mana.max end
    -- Calculate SP
    player.Stamina.max = player.Characteristics.Strength + player.Characteristics.Willpower + player.Characteristics.Agility + player.Characteristics.Endurance
    if player.Stamina.current > player.Stamina.max then player.Stamina.current = player.Stamina.max end

    updateSave()
end

-- Function to update save data
function updateSave()
    local savedData = JSON.encode(saveInfoPlayer)
    getObjectFromGUID(saveCube).setGMNotes(savedData)
end

-- Set the player's race
local function setRaceInfo(colorPlayer, raceData)
    local race = saveInfoPlayer[colorPlayer].Race
    saveInfoPlayer[colorPlayer].Buffs.RaceSkills = deepCopy(raceData[race].skills)
    saveInfoPlayer[colorPlayer].Buffs.RaceCharacteristics = deepCopy(raceData[race].characteristics)
    saveInfoPlayer[colorPlayer].MagicBonus = raceData[race].MagicBonus or 0
end
function changeRaceBonus(colorPlayer)
    WebRequest.get("https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/RaceInfo.json",
        function(request)
            setRaceInfo(colorPlayer, JSON.decode(request.text))
        end
    )
end

-- Set the player's class
local function setClassInfo(colorPlayer, classData)
    local class = saveInfoPlayer[colorPlayer].Class
    saveInfoPlayer[colorPlayer].Buffs.ClassSkills = deepCopy(classData[class].skills)
    saveInfoPlayer[colorPlayer].Buffs.ClassCharacteristics = deepCopy(classData[class].characteristics)
end
function changeClassBonus(colorPlayer)
    WebRequest.get("https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/ClassInfo.json",
        function(request)
            setClassInfo(colorPlayer, JSON.decode(request.text))
        end
    )
end

-- Function to sort skills by importance
function sortSkillsByImportance(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    local sortedSkills = {}

    -- Add major skills
    table.insert(sortedSkills, {name = "Major Skills"})
    for skill, _ in pairs(player.Buffs.ClassSkills.majorSkills) do
        if player.Skills[skill] then
            table.insert(sortedSkills, {name = skill, value = player.Skills[skill]})
        end
    end

    -- Add minor skills
    table.insert(sortedSkills, {name = "Minor Skills"})
    for skill, _ in pairs(player.Buffs.ClassSkills.minorSkills) do
        if player.Skills[skill] then
            table.insert(sortedSkills, {name = skill, value = player.Skills[skill]})
        end
    end

    -- Add miscellaneous skills
    table.insert(sortedSkills, {name = "Misc Skills"})
    for skill, _ in pairs(player.Skills) do
        local flag = true
        for index, v in ipairs(sortedSkills) do
            if v.name == skill then
                flag = false
                break
            end
        end
        if(flag) then table.insert(sortedSkills, {name = skill, value = player.Skills[skill]}) end
    end

    -- Update XML form with sorted skills
    local xmlTable = self.UI.getXmlTable()
    local skillsTable = xmlTable[2].children[enumColor[colorPlayer]].children[4].children[1].children[1].children
    for i, skillEntry in ipairs(sortedSkills) do
        -- Update skill value id
        skillsTable[i].children[2].children[1].children[1].attributes.id = colorPlayer .. skillEntry.name
        -- Update skill name
        skillsTable[i].children[1].children[1].children[1].attributes.text = skillEntry.name
    end

    self.UI.setXmlTable(xmlTable)
end

-- Set the player's sign
local function setSignInfo(colorPlayer, signData)
end
function changeSignBonus(colorPlayer)
    WebRequest.get("https://raw.githubusercontent.com/Borbold/M_TTS/refs/heads/main/Data/SignInfo.json",
        function(request)
            setSignInfo(colorPlayer, JSON.decode(request.text))
        end
    )
end
-- Global functions --