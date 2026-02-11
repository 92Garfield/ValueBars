-- ValueBarsOptions: Options panel for ValueBars addon
-- Author: Demonperson a.k.a. 92Garfield

local name, addon = ...

-- Namespace
ValueBars.Options = {}

--[[----------------------------------------------------------------------------
Defaults
------------------------------------------------------------------------------]]
local function Color(r, g, b, a)
    local t = {}
    t.r = r
    t.g = g
    t.b = b
    t.a = a or 1
    return t
end

--[[----------------------------------------------------------------------------
Bar Textures
------------------------------------------------------------------------------]]
local barTextures = {
    ["Blizzard"] = "Interface\\TargetingFrame\\UI-StatusBar",
    ["Blizzard Raid Bar"] = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",
    ["Smooth"] = "Interface\\Buttons\\WHITE8X8"
}

local defaults = {
    global = {
        enabled = true,
        updateInterval = 0.1, -- Update interval in seconds
        bars = {
            health = {
                enabled = true,
                width = 200,
                height = 20,
                posX = 0,
                posY = 0,
                color = Color(0, 1, 0, 1), -- Green
                texture = "Blizzard",
                bgOpacity = 0.5,
                showText = false,
                hideOutOfCombat = false,
                hideWhenEmpty = false
            },
            absorbDamage = {
                enabled = true,
                width = 200,
                height = 20,
                posX = 0,
                posY = -30,
                color = Color(0.5, 0.5, 1, 1), -- Blue
                texture = "Blizzard",
                bgOpacity = 0.5,
                showText = false,
                hideOutOfCombat = false,
                hideWhenEmpty = false
            },
            absorbHeal = {
                enabled = true,
                width = 200,
                height = 20,
                posX = 0,
                posY = -60,
                color = Color(1, 1, 0, 1), -- Yellow
                texture = "Blizzard",
                bgOpacity = 0.5,
                showText = false,
                hideOutOfCombat = false,
                hideWhenEmpty = false
            }
        }
    }
}

--[[----------------------------------------------------------------------------
Bar Configuration
------------------------------------------------------------------------------]]
local barConfigs = {
    {
        key = "health",
        name = "Health Bar",
        order = 2
    },
    {
        key = "absorbDamage",
        name = "Absorb Damage Bar",
        order = 3
    },
    {
        key = "absorbHeal",
        name = "Absorb Heal Bar",
        order = 4
    }
}

--[[----------------------------------------------------------------------------
Generate Bar Options
------------------------------------------------------------------------------]]
local function GenerateBarOptions(barKey, barName)
    return {
        name = barName .. " Settings",
        type = "header",
        order = 1
    }, {
        enabled = {
            name = "Enable " .. barName,
            desc = "Show or hide the " .. barName:lower(),
            type = "toggle",
            order = 2,
            width = "full",
            get = function(info)
                return ValueBars.db.global.bars[barKey].enabled
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].enabled = val
                ValueBars:UpdateBars()
            end
        },
        width = {
            name = "Width",
            desc = "Set the width of the " .. barName:lower(),
            type = "range",
            order = 3,
            min = 100,
            max = 500,
            step = 1,
            get = function(info)
                return ValueBars.db.global.bars[barKey].width
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].width = val
                ValueBars:UpdateBars()
            end
        },
        height = {
            name = "Height",
            desc = "Set the height of the " .. barName:lower(),
            type = "range",
            order = 4,
            min = 10,
            max = 50,
            step = 1,
            get = function(info)
                return ValueBars.db.global.bars[barKey].height
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].height = val
                ValueBars:UpdateBars()
            end
        },
        color = {
            name = "Bar Color",
            desc = "Set the color of the " .. barName:lower(),
            type = "color",
            order = 5,
            hasAlpha = true,
            get = function(info)
                local c = ValueBars.db.global.bars[barKey].color
                return c.r, c.g, c.b, c.a
            end,
            set = function(info, r, g, b, a)
                ValueBars.db.global.bars[barKey].color = Color(r, g, b, a)
                ValueBars:UpdateBars()
            end
        },
        texture = {
            name = "Bar Texture",
            desc = "Select a preset texture for the " .. barName:lower(),
            type = "select",
            order = 6,
            width = "normal",
            values = function()
                local textureNames = {}
                for name, _ in pairs(barTextures) do
                    textureNames[name] = name
                end
                return textureNames
            end,
            get = function(info)
                return ValueBars.db.global.bars[barKey].texture or "Blizzard"
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].texture = val
                ValueBars.db.global.bars[barKey].textureCustom = nil
                ValueBars:UpdateBars()
            end
        },
        textureCustom = {
            name = "Custom Texture Path",
            desc = "Enter a custom texture path (overrides preset selection)",
            type = "input",
            order = 6.5,
            width = "normal",
            get = function(info)
                return ValueBars.db.global.bars[barKey].textureCustom or ""
            end,
            set = function(info, val)
                if val and val ~= "" then
                    ValueBars.db.global.bars[barKey].textureCustom = val
                else
                    ValueBars.db.global.bars[barKey].textureCustom = nil
                end
                ValueBars:UpdateBars()
            end
        },
        posX = {
            name = "Position X",
            desc = "Horizontal position offset from center",
            type = "range",
            order = 7,
            min = -1000,
            max = 1000,
            step = 1,
            get = function(info)
                return ValueBars.db.global.bars[barKey].posX
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].posX = val
                ValueBars:UpdateBars()
            end
        },
        posY = {
            name = "Position Y",
            desc = "Vertical position offset from center",
            type = "range",
            order = 8,
            min = -1000,
            max = 1000,
            step = 1,
            get = function(info)
                return ValueBars.db.global.bars[barKey].posY
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].posY = val
                ValueBars:UpdateBars()
            end
        },
        bgOpacity = {
            name = "Background Opacity",
            desc = "Set the opacity of the background",
            type = "range",
            order = 9,
            min = 0,
            max = 1,
            step = 0.01,
            get = function(info)
                return ValueBars.db.global.bars[barKey].bgOpacity
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].bgOpacity = val
                ValueBars:UpdateBars()
            end
        },
        showText = {
            name = "Show Text",
            desc = "Display the current value as text on the bar",
            type = "toggle",
            order = 10,
            width = "full",
            get = function(info)
                return ValueBars.db.global.bars[barKey].showText
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].showText = val
                ValueBars:UpdateBars()
            end
        },
        hideOutOfCombat = {
            name = "Hide While Out of Combat",
            desc = "Hide the bar when you are not in combat",
            type = "toggle",
            order = 11,
            width = "full",
            get = function(info)
                return ValueBars.db.global.bars[barKey].hideOutOfCombat
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].hideOutOfCombat = val
            end
        },
        hideWhenEmpty = {
            name = "Hide When Empty",
            desc = "Hide when value is 0",
            type = "toggle",
            order = 12,
            width = "full",
            get = function(info)
                return ValueBars.db.global.bars[barKey].hideWhenEmpty
            end,
            set = function(info, val)
                ValueBars.db.global.bars[barKey].hideWhenEmpty = val
                ValueBars:UpdateBars()
            end
        }
    }
end

--[[----------------------------------------------------------------------------
Options
------------------------------------------------------------------------------]]
local options = {
    name = "ValueBars",
    handler = ValueBars.Options,
    type = "group",
    childGroups = "tab",
    args = {
        generalTab = {
            name = "General",
            type = "group",
            order = 1,
            args = {
                headerGeneral = {
                    name = "General Settings",
                    type = "header",
                    order = 1
                },
                enabled = {
                    name = "Enable ValueBars",
                    desc = "Enable or disable all bars",
                    type = "toggle",
                    order = 2,
                    width = "full",
                    get = function(info)
                        return ValueBars.db.global.enabled
                    end,
                    set = function(info, val)
                        ValueBars.db.global.enabled = val
                        if val then
                            ValueBars:ShowAll()
                        else
                            ValueBars:HideAll()
                        end
                    end
                },
                updateInterval = {
                    name = "Update Interval",
                    desc = "How often to update bars (in seconds)",
                    type = "range",
                    order = 3,
                    min = 0.01,
                    max = 1,
                    step = 0.01,
                    get = function(info)
                        return ValueBars.db.global.updateInterval
                    end,
                    set = function(info, val)
                        ValueBars.db.global.updateInterval = val
                        ValueBars:RestartUpdateTimer()
                    end
                }
            }
        }
    }
}

-- Generate bar tabs dynamically
for _, barConfig in ipairs(barConfigs) do
    local header, barOptions = GenerateBarOptions(barConfig.key, barConfig.name)
    local tabKey = barConfig.key .. "Tab"
    
    options.args[tabKey] = {
        name = barConfig.name,
        type = "group",
        order = barConfig.order,
        args = {}
    }
    
    options.args[tabKey].args["header" .. barConfig.key:gsub("^%l", string.upper)] = header
    
    for optionKey, optionValue in pairs(barOptions) do
        options.args[tabKey].args[optionKey] = optionValue
    end
end

--[[----------------------------------------------------------------------------
Initialize Options
------------------------------------------------------------------------------]]
function ValueBars.Options:Initialize()
    -- Initialize AceDB
    ValueBars.db = LibStub("AceDB-3.0"):New("ValueBarsDB", defaults)
    
    -- Register options table
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("ValueBars", options)
    
    -- Add to Blizzard options
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ValueBars", "ValueBars")
    
    print("ValueBars options panel registered!")
end

-- Open the options panel
function ValueBars.Options:Open()
    -- Open to Interface -> AddOns -> ValueBars
    -- InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    -- InterfaceOptionsFrame_OpenToCategory(self.optionsFrame) -- Called twice due to Blizzard bug
end

-- Get defaults
ValueBars.Options.defaults = defaults

-- Get texture path from texture name
function ValueBars.Options:GetTexturePath(textureName, customPath)
    -- Prioritize custom path if provided
    if customPath and customPath ~= "" then
        return customPath
    end
    
    -- Otherwise use preset texture
    return barTextures[textureName] or barTextures["Blizzard"]
end