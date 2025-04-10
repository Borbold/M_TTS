-- Default XML information
local procuredXMLForm = {
    tag = "GridLayout",
    attributes = {id = "mainPanel", active = "true", startAxis = "Vertical", padding = "3 3 3 3", spacing = "3 3", cellSize = "230 66", color = "Black"},
    children = {}
}
-- Helper function to create a row with name and value
local function createRow(name, value, valueType, nameClass, valueClass, valueTag)
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
                        children = valueType == "progress" and {
                            {
                                tag = "ProgressBar",
                                attributes = {id = value .. "PB", class = "statePB", image = "States_Back", fillImage = value .. "_Fill"}
                            },
                            {
                                tag = "Text",
                                attributes = {id = value, text = "20/100", class = "progressBarV"}
                            }
                        } or {
                            {
                                tag = valueTag,
                                attributes = {id = value, text = "10", class = valueClass}
                            }
                        }
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
            tag = "TableLayout",
            attributes = {width = "230", height = "175", offsetXY = "0 -55", image = "TableLayout_Back_Long"},
            children = rows
        }
    }
end
-- Helper function to create a skills table layout
local function createSkillsTableLayout(rows)
    return {
        tag = "Row",
        children = {
            tag = "VerticalScrollView",
            attributes = {width = "230", height = "313", offsetXY = "235 84", image = "TableLayout_Back_Long"},
            children = {
                tag = "TableLayout",
                attributes = {width = "190", height = "666"},
                children = rows
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
        createRow("Strenght", "Strenght", "value", "gameInfo", "stateV", "Button"),
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
        createRow("Hand-to-Hand", "HandToHand", "value", "skillsInfo", "stateV", "Button"),
        createRow("Mercantile", "Mercantile", "value", "skillsInfo", "stateV", "Button"),
        createRow("Speechcraft", "Speechcraft", "value", "skillsInfo", "stateV", "Button")
    })
}
-- Default XML information --

-- Global variable --
local baseInfoPlayer = {
    Health = {current = 30, max = 100},
    Mana = {current = 30, max = 100},
    Stamina = {current = 30, max = 100},
    Level = "1", Race = "Default", Class = "Default", Sign = "Default",
    Characteristics = {
        Strenght = 5, Intelligence = 5, Willpower = 5, Agility = 5, Speed = 5,
        Endurance = 5, Personality = 5, Luck = 5
    },
    Skills = {
        LongBlade = 5, Axe = 5, BluntWeapon = 5, Armorer = 5, MediumArmor = 5,
        HeavyArmor = 5, Spear = 5, Block = 5, Athletics = 5, Alchemy = 5,
        Enchant = 5, Conjuration = 5, Alteration = 5, Destruction = 5, Mysticism = 5,
        Restoration = 5, Illusion = 5, Unarmored = 5, Acrobatics = 5, Security = 5,
        Sneak = 5, LightArmor = 5, Marksman = 5, ShortBlade = 5, HandToHand = 5,
        Mercantile = 5, Speechcraft = 5
    }
}
-- f77b1d - Guid player save cube
saveInfoPlayer = {
    Red = {}, White = {}, Blue = {},
}
local enumColor = {
    Red = 1, White = 2, Blue = 3,
}
local indexVisibilityColor = 1
local listColor = {
    "Red", "White", "Blue",
}
-- Global variable --

function UpdateSave()
    local savedData = JSON.encode(saveInfoPlayer)
    getObjectFromGUID("f77b1d").setGMNotes(savedData)
end

function onLoad()
    addHotkey("GM Inventory", function(playerColor)
        if(playerColor == "Black") then
            ActivateInventoryForGM(listColor[indexVisibilityColor])
        end
    end)
    addHotkey("Player Inventory", function(playerColor) ActivateInventory(playerColor) end)
    for color,_ in pairs(enumColor) do
        saveInfoPlayer[color] = DeepCopy(baseInfoPlayer)
    end
    Wait.time(function()
        RebuildXMLTable()
        local savedData = getObjectFromGUID("f77b1d").getGMNotes()
        --local saveInfoPlayer = JSON.decode(savedData)
        if(saveInfoPlayer) then
            Wait.time(|| Confer(saveInfoPlayer), 1)
        else
            print("Fail get save. ReSave.")
            Wait.time(|| Confer(), 1)
            UpdateSave()
        end
    end, 1)
end

function ActivateInventory(playerColor)
    local cId = playerColor.."mainPanel"
    self.UI.setAttribute(cId, "active", self.UI.getAttribute(cId, "active") == "true" and "false" or "true")
end
function ActivateInventoryForGM(playerColor)
    if(playerColor) then
        local cId, pId = playerColor.."mainPanel", listColor[indexVisibilityColor > 1 and indexVisibilityColor - 1 or 1].."mainPanel"
        self.UI.setAttribute(cId, "active", "true")
        self.UI.setAttribute(pId, "visibility", playerColor)
        self.UI.setAttribute(cId, "visibility", playerColor.."|Black")
    end
    indexVisibilityColor = indexVisibilityColor + 1
    if(indexVisibilityColor > #listColor + 1) then
        self.UI.setAttribute(listColor[#listColor].."mainPanel", "visibility", listColor[#listColor])
        indexVisibilityColor = 1
    end
end

function Confer(saveInfoPlayer)
    --saveInfoPlayer = saveInfoPlayer
    for color,_ in pairs(saveInfoPlayer) do
        CalculateInfo(color)
        SetUI(color)
    end
end

function CalculateInfo(colorPlayer)
    local player = saveInfoPlayer[colorPlayer]
    -------------
    player.Health.max = (player.Characteristics.Strenght + player.Characteristics.Endurance)/2 + (tonumber(player.Level) - 1)*(player.Characteristics.Endurance/10)
    if(player.Health.current > player.Health.max) then player.Health.current = player.Health.max end
    -------------
    player.Mana.max = player.Characteristics.Intelligence*(1--[[Рассовый модификатор + Модификатор знака рождения]])
    if(player.Mana.current > player.Mana.max) then player.Mana.current = player.Mana.max end
    -------------
    player.Stamina.max = player.Characteristics.Strenght + player.Characteristics.Willpower + player.Characteristics.Agility + player.Characteristics.Endurance
    if(player.Stamina.current > player.Stamina.max) then player.Stamina.current = player.Stamina.max end
    -------------
    local xmlTable = {} xmlTable = self.UI.getXmlTable()
    -- Major Skills +30, Main Skills +15, Misc Skills +5
    local locId = ""
    for index,state in ipairs(xmlTable[2].children[enumColor[colorPlayer]].children[4].children[1].children[1].children) do
        if(index < 7) then
            locId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
            player.Skills[locId] = 30
        elseif(index < 13) then
            locId = state.children[2].children[1].children[1].attributes.id:gsub(colorPlayer, "")
            player.Skills[locId] = 15
        end
    end
    -------------
    UpdateSave()
end

function SetUI(colorPlayer)
    local state = saveInfoPlayer[colorPlayer]
    for n,v in pairs(state) do
        if(type(v) == "string") then -- Other
            self.UI.setAttribute(colorPlayer..n, "text", v)
        else
            if(v.current and v.max) then -- HP, MP, SP
                self.UI.setAttribute(colorPlayer..n, "text", v.current.."/"..v.max)
            else -- Characteristics, Skills
                for sN,sV in pairs(v) do
                    self.UI.setAttribute(colorPlayer..sN, "text", sV)
                    self.UI.setAttribute(colorPlayer..sN, "textColor", self.UI.getAttribute(colorPlayer..sN, "textColor"))
                end
            end
        end
    end
    -- Percent state progress bar value
    self.UI.setAttribute(colorPlayer.."HealthPB", "percentage", (state.Health.current/state.Health.max)*100)
    self.UI.setAttribute(colorPlayer.."ManaPB", "percentage", (state.Mana.current/state.Mana.max)*100)
    self.UI.setAttribute(colorPlayer.."StaminaPB", "percentage", (state.Stamina.current/state.Stamina.max)*100)
end

function RebuildXMLTable()
    local xmlTable = {} xmlTable = self.UI.getXmlTable()
    local mainPanel = xmlTable[2].children
    local locId = ""
    for colorPlayer,_ in pairs(saveInfoPlayer) do
        local newPXMLF = {} newPXMLF = DeepCopy(procuredXMLForm)
        locId = newPXMLF.attributes.id
        newPXMLF.attributes.id = colorPlayer..locId
        newPXMLF.attributes.visibility = colorPlayer
        for i = 1, #procuredXMLForm.children do
            -- HP, MP, SP, Level, Race, Class
            for j = 1, #newPXMLF.children[i].children do
                for k = 1, #newPXMLF.children[i].children[j].children[2].children[1].children do
                    locId = newPXMLF.children[i].children[j].children[2].children[1].children[k].attributes.id
                    newPXMLF.children[i].children[j].children[2].children[1].children[k].attributes.id = colorPlayer..locId
                end
            end
        end
        -- Characteristics
        for j = 1, #newPXMLF.children[3].children.children do
            locId = newPXMLF.children[3].children.children[j].children[2].children[1].children[1].attributes.id
            newPXMLF.children[3].children.children[j].children[2].children[1].children[1].attributes.id = colorPlayer..locId
        end
        -- Skills
        for j = 1, #newPXMLF.children[4].children.children.children do
            locId = newPXMLF.children[4].children.children.children[j].children[2].children[1].children[1].attributes.id
            newPXMLF.children[4].children.children.children[j].children[2].children[1].children[1].attributes.id = colorPlayer..locId
        end
        table.insert(mainPanel, newPXMLF)
    end
    self.UI.setXmlTable(xmlTable)
end

function ThrowSkill(player, alt, id)
    local RV, CV = math.random(1, 100), tonumber(self.UI.getAttribute(id, "text"))
    print(RV <= CV and "[00ff00]Succses[-]" or "[ff0000]Failure[-]")
end

-- Thecnics function
function DeepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            value = DeepCopy(value) -- Recursively copy nested tables
        end
        copy[key] = value
    end
    return copy
end