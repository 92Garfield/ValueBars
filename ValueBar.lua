-- ValueBar class: Individual StatusBar instance
-- Author: Demonperson a.k.a. 92Garfield

-- Namespace
if not ValueBars then
    ValueBars = {}
end

-- Enums for display types
ValueBars.DisplayType = {
    HEALTH = 1,
    ABSORB_DAMAGE = 2,
    ABSORB_HEAL = 3
}

-- ValueBar class
local ValueBar = {}
ValueBar.__index = ValueBar

-- Constructor
function ValueBars:CreateBar(parent, displayType)
    local instance = setmetatable({}, ValueBar)
    
    -- Create the StatusBar frame
    instance.frame = CreateFrame("StatusBar", nil, parent or UIParent)
    instance.frame:SetSize(200, 20)
    instance.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    instance.frame:SetMinMaxValues(0, 100)
    instance.frame:SetValue(0)
    instance.frame:SetFrameStrata("MEDIUM")
    instance.frame:SetFrameLevel(10)
    
    -- Create background
    instance.bg = instance.frame:CreateTexture(nil, "BACKGROUND")
    instance.bg:SetAllPoints(instance.frame)
    instance.bg:SetColorTexture(0, 0, 0, 0.5)
    
    -- Create text frame
    instance.text = instance.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    instance.text:SetPoint("CENTER", instance.frame, "CENTER", 0, 0)
    instance.text:SetText("")
    instance.text:Hide() -- Hidden by default
    
    -- Set the display type
    instance.displayType = displayType or ValueBars.DisplayType.HEALTH
    
    -- Store reference to settings (will be set later)
    instance.settings = nil
    
    -- Visibility state (separate from frame visibility)
    instance.visible = true
    
    -- Initialize based on type
    instance:InitializeByType()
    
    -- Show by default
    instance.frame:Show()
    
    return instance
end

-- Initialize based on display type
function ValueBar:InitializeByType()
    if self.displayType == ValueBars.DisplayType.HEALTH then
        self:InitializeHealth()
    elseif self.displayType == ValueBars.DisplayType.ABSORB_DAMAGE then
        self:InitializeAbsorbDamage()
    elseif self.displayType == ValueBars.DisplayType.ABSORB_HEAL then
        self:InitializeAbsorbHeal()
    end
end

-- Initialize as Health bar
function ValueBar:InitializeHealth()
    -- Set texture and color
    self.frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.frame:SetStatusBarColor(0, 1, 0, 1) -- Green
end

-- Update health bar values
function ValueBar:UpdateHealth()
    local health = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    
    self:SetValue(health, maxHealth)
end

-- Initialize as Absorb Damage bar
function ValueBar:InitializeAbsorbDamage()
    -- Set texture and color
    self.frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.frame:SetStatusBarColor(0.5, 0.5, 1, 1) -- Blue
end

-- Update absorb damage bar values
function ValueBar:UpdateAbsorbDamage()
    local totalAbsorb = UnitGetTotalAbsorbs("player")
    local maxHealth = UnitHealthMax("player")
    
    self:SetValue(totalAbsorb or 0, maxHealth)
end

-- Initialize as Absorb Heal bar
function ValueBar:InitializeAbsorbHeal()
    -- Set texture and color
    self.frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.frame:SetStatusBarColor(1, 1, 0, 1) -- Yellow
end

-- Update absorb heal bar values
function ValueBar:UpdateAbsorbHeal()
    local healAbsorb = UnitGetTotalHealAbsorbs("player")
    local maxHealth = UnitHealthMax("player")
    
    self:SetValue(healAbsorb or 0, maxHealth)
end

-- Update the bar based on its type
function ValueBar:Update()
    -- Don't update if not visible
    if not self.visible then
        return
    end
    
    if self.displayType == ValueBars.DisplayType.HEALTH then
        self:UpdateHealth()
    elseif self.displayType == ValueBars.DisplayType.ABSORB_DAMAGE then
        self:UpdateAbsorbDamage()
    elseif self.displayType == ValueBars.DisplayType.ABSORB_HEAL then
        self:UpdateAbsorbHeal()
    end
end

-- Update the bar value
function ValueBar:SetValue(current, max)
    self.frame:SetMinMaxValues(0, max)
    self.frame:SetValue(current)

    -- Update text if enabled
    if self.settings and self.settings.showText and self.text then
        self.text:SetText(AbbreviateLargeNumbers(current))
    end

    self:CheckHide(current)
end

--check if the bar should be hidden
function ValueBar:CheckHide(value)
    if not value then
        self:Hide()
        return
    end
    
    -- Check if value is actually a number we can compare
    if not issecretvalue(value) then --this is correct, don't change
        if value <= 0 then
            self:Hide()
        else
            self:Show()
        end
    else
        -- If it's not a number (could be a userdata/secret value), show it
        self:Show()
    end
end

-- Show the bar
function ValueBar:Show()
    -- Check if settings exist and bar is enabled
    if self.settings and not self.settings.enabled then
        return
    end
    
    self.frame:Show()
end

-- Hide the bar
function ValueBar:Hide()
    self.frame:Hide()
end

-- Set visibility based on enabled and combat state
function ValueBar:SetVisible(inCombat)
    -- Check if bar is enabled
    if not self.settings or not self.settings.enabled then
        self.visible = false
        self:Hide()
        return
    end
    
    -- Check if hideOutOfCombat is enabled
    if self.settings.hideOutOfCombat and not inCombat then
        self.visible = false
        self:Hide()
        return
    end
    
    -- Bar should be visible
    self.visible = true
    self:Show()
end

-- Set position
function ValueBar:SetPoint(...)
    self.frame:SetPoint(...)
end

-- Set size
function ValueBar:SetSize(width, height)
    self.frame:SetSize(width, height)
end

-- Set background opacity
function ValueBar:SetBackgroundOpacity(opacity)
    if self.bg then
        self.bg:SetColorTexture(0, 0, 0, opacity)
    end
end

-- Set text visibility
function ValueBar:SetTextVisible(visible)
    if self.text then
        if visible then
            self.text:Show()
        else
            self.text:Hide()
        end
    end
end

-- Destroy the bar and cleanup
function ValueBar:Destroy()
    if self.frame then
        self.frame:Hide()
        self.frame = nil
    end
end
