-- ValueBars: A WoW addon to show values as StatusBars
-- Main addon file
-- Author: Demonperson a.k.a. 92Garfield

-- Namespace
ValueBars = ValueBars or {}

-- Addon variables
ValueBars.version = "1.0.0"
ValueBars.bars = {}

-- Initialize the addon
function ValueBars:Initialize()
    print("ValueBars v" .. self.version .. " loaded!")

    -- Initialize options panel (this also initializes AceDB)
    self.Options:Initialize()

    -- Create all three bar types
    self:CreateAllBars()

    -- Start the update timer
    self:StartUpdateTimer()

    print("> All bars created and initialized.")
end

-- Create all bar types
function ValueBars:CreateAllBars()
    if not self.db then
        return
    end
    
    -- Health bar
    local healthBar = self:NewBar(UIParent, ValueBars.DisplayType.HEALTH)
    local healthSettings = self.db.global.bars.health
    healthBar.settings = healthSettings
    healthBar:SetPoint("CENTER", UIParent, "CENTER", healthSettings.posX, healthSettings.posY)
    healthBar:SetSize(healthSettings.width, healthSettings.height)
    healthBar.frame:SetStatusBarColor(healthSettings.color.r, healthSettings.color.g, healthSettings.color.b, healthSettings.color.a)
    healthBar:SetBackgroundOpacity(healthSettings.bgOpacity)
    healthBar:SetTextVisible(healthSettings.showText)
    if healthSettings.enabled then
        healthBar:Show()
    else
        healthBar:Hide()
    end
    self.healthBar = healthBar
    
    -- Absorb Damage bar
    local absorbDamageBar = self:NewBar(UIParent, ValueBars.DisplayType.ABSORB_DAMAGE)
    local absorbDamageSettings = self.db.global.bars.absorbDamage
    absorbDamageBar.settings = absorbDamageSettings
    absorbDamageBar:SetPoint("CENTER", UIParent, "CENTER", absorbDamageSettings.posX, absorbDamageSettings.posY)
    absorbDamageBar:SetSize(absorbDamageSettings.width, absorbDamageSettings.height)
    absorbDamageBar.frame:SetStatusBarColor(absorbDamageSettings.color.r, absorbDamageSettings.color.g, absorbDamageSettings.color.b, absorbDamageSettings.color.a)
    absorbDamageBar:SetBackgroundOpacity(absorbDamageSettings.bgOpacity)
    absorbDamageBar:SetTextVisible(absorbDamageSettings.showText)
    if absorbDamageSettings.enabled then
        absorbDamageBar:Show()
    else
        absorbDamageBar:Hide()
    end
    self.absorbDamageBar = absorbDamageBar
    
    -- Absorb Heal bar
    local absorbHealBar = self:NewBar(UIParent, ValueBars.DisplayType.ABSORB_HEAL)
    local absorbHealSettings = self.db.global.bars.absorbHeal
    absorbHealBar.settings = absorbHealSettings
    absorbHealBar:SetPoint("CENTER", UIParent, "CENTER", absorbHealSettings.posX, absorbHealSettings.posY)
    absorbHealBar:SetSize(absorbHealSettings.width, absorbHealSettings.height)
    absorbHealBar.frame:SetStatusBarColor(absorbHealSettings.color.r, absorbHealSettings.color.g, absorbHealSettings.color.b, absorbHealSettings.color.a)
    absorbHealBar:SetBackgroundOpacity(absorbHealSettings.bgOpacity)
    absorbHealBar:SetTextVisible(absorbHealSettings.showText)
    if absorbHealSettings.enabled then
        absorbHealBar:Show()
    else
        absorbHealBar:Hide()
    end
    self.absorbHealBar = absorbHealBar
end

-- Create a new bar and track it
function ValueBars:NewBar(parent, displayType)
    local bar = self:CreateBar(parent, displayType)
    table.insert(self.bars, bar)
    return bar
end

-- Remove a bar
function ValueBars:RemoveBar(bar)
    for i, b in ipairs(self.bars) do
        if b == bar then
            if bar.Destroy then
                bar:Destroy()
            else
                bar:Hide()
            end
            table.remove(self.bars, i)
            break
        end
    end
end

-- Show all bars
function ValueBars:ShowAll()
    for _, bar in ipairs(self.bars) do
        bar:Show()
    end
end

-- Hide all bars
function ValueBars:HideAll()
    for _, bar in ipairs(self.bars) do
        bar:Hide()
    end
end

-- Update all bars based on settings
function ValueBars:UpdateBars()
    if not self.db then
        return
    end
    
    -- Update health bar
    if self.healthBar then
        local settings = self.db.global.bars.health
        self.healthBar:SetSize(settings.width, settings.height)
        self.healthBar.frame:ClearAllPoints()
        self.healthBar:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
        if settings.color then
            self.healthBar.frame:SetStatusBarColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
        end
        if settings.bgOpacity then
            self.healthBar:SetBackgroundOpacity(settings.bgOpacity)
        end
        self.healthBar:SetTextVisible(settings.showText)
        if settings.enabled then
            self.healthBar:Show()
        else
            self.healthBar:Hide()
        end
    end
    
    -- Update absorb damage bar
    if self.absorbDamageBar then
        local settings = self.db.global.bars.absorbDamage
        self.absorbDamageBar:SetSize(settings.width, settings.height)
        self.absorbDamageBar.frame:ClearAllPoints()
        self.absorbDamageBar:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
        if settings.color then
            self.absorbDamageBar.frame:SetStatusBarColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
        end
        if settings.bgOpacity then
            self.absorbDamageBar:SetBackgroundOpacity(settings.bgOpacity)
        end
        self.absorbDamageBar:SetTextVisible(settings.showText)
        if settings.enabled then
            self.absorbDamageBar:Show()
        else
            self.absorbDamageBar:Hide()
        end
    end
    
    -- Update absorb heal bar
    if self.absorbHealBar then
        local settings = self.db.global.bars.absorbHeal
        self.absorbHealBar:SetSize(settings.width, settings.height)
        self.absorbHealBar.frame:ClearAllPoints()
        self.absorbHealBar:SetPoint("CENTER", UIParent, "CENTER", settings.posX, settings.posY)
        if settings.color then
            self.absorbHealBar.frame:SetStatusBarColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
        end
        if settings.bgOpacity then
            self.absorbHealBar:SetBackgroundOpacity(settings.bgOpacity)
        end
        self.absorbHealBar:SetTextVisible(settings.showText)
        if settings.enabled then
            self.absorbHealBar:Show()
        else
            self.absorbHealBar:Hide()
        end
    end
end

-- Update all bar values
function ValueBars:UpdateAllBarValues()
    if not self.db or not self.db.global.enabled then
        return
    end
    
    if self.healthBar and self.db.global.bars.health.enabled then
        self.healthBar:Update()
    end
    
    if self.absorbDamageBar and self.db.global.bars.absorbDamage.enabled then
        self.absorbDamageBar:Update()
    end
    
    if self.absorbHealBar and self.db.global.bars.absorbHeal.enabled then
        self.absorbHealBar:Update()
    end
end

-- Start the update timer
function ValueBars:StartUpdateTimer()
    if not self.db then
        return
    end
    
    -- Cancel existing timer if any
    if self.updateTimer then
        self.updateTimer:Cancel()
    end
    
    local interval = self.db.global.updateInterval or 0.1
    
    -- Create repeating timer
    self.updateTimer = C_Timer.NewTicker(interval, function()
        ValueBars:UpdateAllBarValues()
    end)
    
    print("ValueBars: Update timer started (interval: " .. interval .. "s)")
end

-- Restart the update timer (called when interval changes)
function ValueBars:RestartUpdateTimer()
    self:StartUpdateTimer()
end

-- Event handler
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "ValueBars" then
        ValueBars:Initialize()
    end
end)

-- Slash commands
SLASH_VALUEBARS1 = "/valuebars"
SLASH_VALUEBARS2 = "/vb"
SlashCmdList["VALUEBARS"] = function(msg)
    msg = msg:lower():trim()
    
    if msg == "" or msg == "config" or msg == "options" then
        ValueBars.Options:Open()
    elseif msg == "show" then
        ValueBars:ShowAll()
        print("ValueBars: All bars shown")
    elseif msg == "hide" then
        ValueBars:HideAll()
        print("ValueBars: All bars hidden")
    elseif msg == "help" then
        print("ValueBars commands:")
        print("  /vb config - Open options panel")
        print("  /vb show - Show all bars")
        print("  /vb hide - Hide all bars")
        print("  /vb help - Show this help")
    else
        print("ValueBars: Unknown command. Type /vb help for commands")
    end
end
