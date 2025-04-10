-- Default XML information
local procuredXMLForm = {
    tag = "GridLayout",
    attributes = {startAxis = "Vertical", padding = "3 3 3 3", spacing = "3 3", cellSize = "230 66", color = "Black"},
    children = {}
}
-- Helper function to create a row with name and value
local function createRow(name, value, valueType, nameClass, valueClass)
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
                                tag = "Text",
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
        createRow("Health", "Health", "progress", "mainInfo", "stateV"),
        createRow("Mana", "Mana", "progress", "mainInfo", "stateV"),
        createRow("Stamina", "Stamina", "progress", "mainInfo", "stateV")
    }),
    createTableLayout({
        createRow("Level", "Level", "value", "mainInfo", "stateV"),
        createRow("Race", "Race", "value", "mainInfo", "stateV"),
        createRow("Class", "Class", "value", "mainInfo", "stateV")
    }),
    createCharacteristicsTableLayout({
        createRow("Strenght", "Strenght", "value", "gameInfo", "stateV"),
        createRow("Intelligence", "Intelligence", "value", "gameInfo", "stateV"),
        createRow("Willpower", "Willpower", "value", "gameInfo", "stateV"),
        createRow("Agility", "Agility", "value", "gameInfo", "stateV"),
        createRow("Speed", "Speed", "value", "gameInfo", "stateV"),
        createRow("Endurance", "Endurance", "value", "gameInfo", "stateV"),
        createRow("Personality", "Personality", "value", "gameInfo", "stateV"),
        createRow("Luck", "Luck", "value", "gameInfo", "stateV")
    }),
    createSkillsTableLayout({
        createRow("Major Skills", "MajorSkills", "value", "mainInfo", "infoSkill"),
        createRow("Long Blade", "LongBlade", "value", "skillsInfo", "stateV"),
        createRow("Axe", "Axe", "value", "skillsInfo", "stateV"),
        createRow("Blunt Weapon", "BluntWeapon", "value", "skillsInfo", "stateV"),
        createRow("Armorer", "Armorer", "value", "skillsInfo", "stateV"),
        createRow("Medium Armor", "MediumArmor", "value", "skillsInfo", "stateV"),
        createRow("Minor Skills", "MinorSkills", "value", "mainInfo", "infoSkill"),
        createRow("Heavy Armor", "HeavyArmor", "value", "skillsInfo", "stateV"),
        createRow("Spear", "Spear", "value", "skillsInfo", "stateV"),
        createRow("Block", "Block", "value", "skillsInfo", "stateV"),
        createRow("Athletics", "Athletics", "value", "skillsInfo", "stateV"),
        createRow("Alchemy", "Alchemy", "value", "skillsInfo", "stateV"),
        createRow("Misc Skills", "MiscSkills", "value", "mainInfo", "infoSkill"),
        createRow("Enchant", "Enchant", "value", "skillsInfo", "stateV"),
        createRow("Conjuration", "Conjuration", "value", "skillsInfo", "stateV"),
        createRow("Alteration", "Alteration", "value", "skillsInfo", "stateV"),
        createRow("Destruction", "Destruction", "value", "skillsInfo", "stateV"),
        createRow("Mysticism", "Mysticism", "value", "skillsInfo", "stateV"),
        createRow("Restoration", "Restoration", "value", "skillsInfo", "stateV"),
        createRow("Illusion", "Illusion", "value", "skillsInfo", "stateV"),
        createRow("Unarmored", "Unarmored", "value", "skillsInfo", "stateV"),
        createRow("Acrobatics", "Acrobatics", "value", "skillsInfo", "stateV"),
        createRow("Security", "Security", "value", "skillsInfo", "stateV"),
        createRow("Sneak", "Sneak", "value", "skillsInfo", "stateV"),
        createRow("Light Armor", "LightArmor", "value", "skillsInfo", "stateV"),
        createRow("Marksman", "Marksman", "value", "skillsInfo", "stateV"),
        createRow("Short Blade", "ShortBlade", "value", "skillsInfo", "stateV"),
        createRow("Hand-to-Hand", "HandToHand", "value", "skillsInfo", "stateV"),
        createRow("Mercantile", "Mercantile", "value", "skillsInfo", "stateV"),
        createRow("Speechcraft", "Speechcraft", "value", "skillsInfo", "stateV")
    })
}
-- Default XML information --

-- Global variable --
saveInfoPlayer = {
    -- f77b1d - Guid player Red info
    Red = {
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
}
-- Global variable --

function UpdateSave()
    local dataToSave = {
        saveInfoPlayer = saveInfoPlayer,
    }
    local savedData = JSON.encode(dataToSave)
    getObjectFromGUID("f77b1d").setGMNotes(savedData)
end

function onLoad()
    addHotkey("Inventory", function() self.UI.setAttribute("mainPanel","active", self.UI.getAttribute("mainPanel","active") == "true" and "false" or "true") end)
    Wait.time(function()
        RebuildXMLTable()
        local savedData = getObjectFromGUID("f77b1d").getGMNotes()
        --local loadedData = JSON.decode(savedData)
        if(loadedData) then
            Wait.time(|| Confer(loadedData), 1)
        else
            print("Fail get save. ReSave.")
            Wait.time(|| Confer(), 1)
            UpdateSave()
        end
    end, 1)
end

function Confer(loadedData)
    --saveInfoPlayer = loadedData.saveInfoPlayer
    CalculateInfo("Red") SetUI()
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
    UpdateSave()
end

function SetUI()
    for colorPlayer,state in pairs(saveInfoPlayer) do
        for n,v in pairs(state) do
            if(type(v) == "string") then -- Other
                self.UI.setAttribute(colorPlayer..n, "text", v)
            else
                if(v.current and v.max) then -- HP, MP, SP
                    self.UI.setAttribute(colorPlayer..n, "text", v.current.."/"..v.max)
                else
                    for sN,sV in pairs(v) do
                        self.UI.setAttribute(colorPlayer..sN, "text", sV)
                    end
                end
            end
        end
        -- Percent state progress bar value
        self.UI.setAttribute(colorPlayer.."HealthPB", "percentage", (state.Health.current/state.Health.max)*100)
        self.UI.setAttribute(colorPlayer.."ManaPB", "percentage", (state.Mana.current/state.Mana.max)*100)
        self.UI.setAttribute(colorPlayer.."StaminaPB", "percentage", (state.Stamina.current/state.Stamina.max)*100)
    end
end

function Test()
    saveInfoPlayer.Red.HP.current = 50
    SetUI()
end

function RebuildXMLTable()
    local xmlTable = {} xmlTable = self.UI.getXmlTable()
    local mainPanel = xmlTable[2].children
    local newPXMLF = {} newPXMLF = procuredXMLForm
    local locId = ""
    for colorPlayer,_ in pairs(saveInfoPlayer) do
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
    --print(JSON.encode(newPXMLF.children[4].children.children.children[5].children))
    --Wait.time(function() print(self.UI.getAttribute("RedAxe", "text")) end, 1)
end