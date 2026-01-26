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
                bgOpacity = 0.5,
                showText = false
            },
            absorbDamage = {
                enabled = true,
                width = 200,
                height = 20,
                posX = 0,
                posY = -30,
                color = Color(0.5, 0.5, 1, 1), -- Blue
                bgOpacity = 0.5,
                showText = false
            },
            absorbHeal = {
                enabled = true,
                width = 200,
                height = 20,
                posX = 0,
                posY = -60,
                color = Color(1, 1, 0, 1), -- Yellow
                bgOpacity = 0.5,
                showText = false
            }
        }
    }
}

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
        },
        healthTab = {
            name = "Health Bar",
            type = "group",
            order = 2,
            args = {
                headerHealth = {
                    name = "Health Bar Settings",
                    type = "header",
                    order = 1
                },
                enabled = {
                    name = "Enable Health Bar",
                    desc = "Show or hide the health bar",
                    type = "toggle",
                    order = 2,
                    width = "full",
                    get = function(info)
                        return ValueBars.db.global.bars.health.enabled
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.health.enabled = val
                        ValueBars:UpdateBars()
                    end
                },
                width = {
                    name = "Width",
                    desc = "Set the width of the health bar",
                    type = "range",
                    order = 3,
                    min = 100,
                    max = 500,
                    step = 10,
                    get = function(info)
                        return ValueBars.db.global.bars.health.width
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.health.width = val
                        ValueBars:UpdateBars()
                    end
                },
                height = {
                    name = "Height",
                    desc = "Set the height of the health bar",
                    type = "range",
                    order = 4,
                    min = 10,
                    max = 50,
                    step = 2,
                    get = function(info)
                        return ValueBars.db.global.bars.health.height
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.health.height = val
                        ValueBars:UpdateBars()
                    end
                },
                color = {
                    name = "Bar Color",
                    desc = "Set the color of the health bar",
                    type = "color",
                    order = 5,
                    hasAlpha = true,
                    get = function(info)
                        local c = ValueBars.db.global.bars.health.color
                        return c.r, c.g, c.b, c.a
                    end,
                    set = function(info, r, g, b, a)
                        ValueBars.db.global.bars.health.color = Color(r, g, b, a)
                        ValueBars:UpdateBars()
                    end
                },
                posX = {
                    name = "Position X",
                    desc = "Horizontal position offset from center",
                    type = "range",
                    order = 6,
                    min = -1000,
                    max = 1000,
                    step = 1,
                    get = function(info)
                        return ValueBars.db.global.bars.health.posX
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.health.posX = val
                        ValueBars:UpdateBars()
                    end
                },
                posY = {
                    name = "Position Y",
                    desc = "Vertical position offset from center",
                    type = "range",
                    order = 7,
                    min = -1000,
                    max = 1000,
                    step = 1,
                    get = function(info)
                        return ValueBars.db.global.bars.health.posY
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.health.posY = val
                        ValueBars:UpdateBars()
                    end
                },
                bgOpacity = {
                    name = "Background Opacity",
                    desc = "Set the opacity of the background",
                    type = "range",
                    order = 8,
                    min = 0,
                    max = 1,
                    step = 0.01,
                    get = function(info)
                        return ValueBars.db.global.bars.health.bgOpacity
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.health.bgOpacity = val
                        ValueBars:UpdateBars()
                    end
                },
                showText = {
                    name = "Show Text",
                    desc = "Display the current value as text on the bar",
                    type = "toggle",
                    order = 9,
                    width = "full",
                    get = function(info)
                        return ValueBars.db.global.bars.health.showText
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.health.showText = val
                        ValueBars:UpdateBars()
                    end
                }
            }
        },
        absorbDamageTab = {
            name = "Absorb Damage Bar",
            type = "group",
            order = 3,
            args = {
                headerAbsorbDamage = {
                    name = "Absorb Damage Bar Settings",
                    type = "header",
                    order = 1
                },
                enabled = {
                    name = "Enable Absorb Damage Bar",
                    desc = "Show or hide the absorb damage bar",
                    type = "toggle",
                    order = 2,
                    width = "full",
                    get = function(info)
                        return ValueBars.db.global.bars.absorbDamage.enabled
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbDamage.enabled = val
                        ValueBars:UpdateBars()
                    end
                },
                width = {
                    name = "Width",
                    desc = "Set the width of the absorb damage bar",
                    type = "range",
                    order = 3,
                    min = 100,
                    max = 500,
                    step = 10,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbDamage.width
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbDamage.width = val
                        ValueBars:UpdateBars()
                    end
                },
                height = {
                    name = "Height",
                    desc = "Set the height of the absorb damage bar",
                    type = "range",
                    order = 4,
                    min = 10,
                    max = 50,
                    step = 2,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbDamage.height
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbDamage.height = val
                        ValueBars:UpdateBars()
                    end
                },
                color = {
                    name = "Bar Color",
                    desc = "Set the color of the absorb damage bar",
                    type = "color",
                    order = 5,
                    hasAlpha = true,
                    get = function(info)
                        local c = ValueBars.db.global.bars.absorbDamage.color
                        return c.r, c.g, c.b, c.a
                    end,
                    set = function(info, r, g, b, a)
                        ValueBars.db.global.bars.absorbDamage.color = Color(r, g, b, a)
                        ValueBars:UpdateBars()
                    end
                },
                posX = {
                    name = "Position X",
                    desc = "Horizontal position offset from center",
                    type = "range",
                    order = 6,
                    min = -1000,
                    max = 1000,
                    step = 1,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbDamage.posX
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbDamage.posX = val
                        ValueBars:UpdateBars()
                    end
                },
                posY = {
                    name = "Position Y",
                    desc = "Vertical position offset from center",
                    type = "range",
                    order = 7,
                    min = -1000,
                    max = 1000,
                    step = 1,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbDamage.posY
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbDamage.posY = val
                        ValueBars:UpdateBars()
                    end
                },
                bgOpacity = {
                    name = "Background Opacity",
                    desc = "Set the opacity of the background",
                    type = "range",
                    order = 8,
                    min = 0,
                    max = 1,
                    step = 0.01,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbDamage.bgOpacity
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbDamage.bgOpacity = val
                        ValueBars:UpdateBars()
                    end
                },
                showText = {
                    name = "Show Text",
                    desc = "Display the current value as text on the bar",
                    type = "toggle",
                    order = 9,
                    width = "full",
                    get = function(info)
                        return ValueBars.db.global.bars.absorbDamage.showText
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbDamage.showText = val
                        ValueBars:UpdateBars()
                    end
                }
            }
        },
        absorbHealTab = {
            name = "Absorb Heal Bar",
            type = "group",
            order = 4,
            args = {
                headerAbsorbHeal = {
                    name = "Absorb Heal Bar Settings",
                    type = "header",
                    order = 1
                },
                enabled = {
                    name = "Enable Absorb Heal Bar",
                    desc = "Show or hide the absorb heal bar",
                    type = "toggle",
                    order = 2,
                    width = "full",
                    get = function(info)
                        return ValueBars.db.global.bars.absorbHeal.enabled
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbHeal.enabled = val
                        ValueBars:UpdateBars()
                    end
                },
                width = {
                    name = "Width",
                    desc = "Set the width of the absorb heal bar",
                    type = "range",
                    order = 3,
                    min = 100,
                    max = 500,
                    step = 10,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbHeal.width
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbHeal.width = val
                        ValueBars:UpdateBars()
                    end
                },
                height = {
                    name = "Height",
                    desc = "Set the width of the absorb heal bar",
                    type = "range",
                    order = 4,
                    min = 10,
                    max = 50,
                    step = 2,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbHeal.height
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbHeal.height = val
                        ValueBars:UpdateBars()
                    end
                },
                color = {
                    name = "Bar Color",
                    desc = "Set the color of the absorb heal bar",
                    type = "color",
                    order = 5,
                    hasAlpha = true,
                    get = function(info)
                        local c = ValueBars.db.global.bars.absorbHeal.color
                        return c.r, c.g, c.b, c.a
                    end,
                    set = function(info, r, g, b, a)
                        ValueBars.db.global.bars.absorbHeal.color = Color(r, g, b, a)
                        ValueBars:UpdateBars()
                    end
                },
                posX = {
                    name = "Position X",
                    desc = "Horizontal position offset from center",
                    type = "range",
                    order = 6,
                    min = -1000,
                    max = 1000,
                    step = 1,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbHeal.posX
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbHeal.posX = val
                        ValueBars:UpdateBars()
                    end
                },
                posY = {
                    name = "Position Y",
                    desc = "Vertical position offset from center",
                    type = "range",
                    order = 7,
                    min = -1000,
                    max = 1000,
                    step = 1,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbHeal.posY
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbHeal.posY = val
                        ValueBars:UpdateBars()
                    end
                },
                bgOpacity = {
                    name = "Background Opacity",
                    desc = "Set the opacity of the background",
                    type = "range",
                    order = 8,
                    min = 0,
                    max = 1,
                    step = 0.01,
                    get = function(info)
                        return ValueBars.db.global.bars.absorbHeal.bgOpacity
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbHeal.bgOpacity = val
                        ValueBars:UpdateBars()
                    end
                },
                showText = {
                    name = "Show Text",
                    desc = "Display the current value as text on the bar",
                    type = "toggle",
                    order = 9,
                    width = "full",
                    get = function(info)
                        return ValueBars.db.global.bars.absorbHeal.showText
                    end,
                    set = function(info, val)
                        ValueBars.db.global.bars.absorbHeal.showText = val
                        ValueBars:UpdateBars()
                    end
                }
            }
        }
    }
}

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