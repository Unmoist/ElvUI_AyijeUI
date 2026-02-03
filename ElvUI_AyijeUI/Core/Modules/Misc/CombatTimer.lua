local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local CT = E:NewModule('CombatTimer', 'AceEvent-3.0')

-- Localize globals
local GetTime = GetTime
local floor = floor
local format = string.format

-- Default settings
P.combatTimer = {
    enable = true,
    width = 150,
    height = 30,
    fontSize = 20,
    font = 'Expressway',
    fontOutline = 'OUTLINE',
}

-- Variables
local combatStartTime = 0
local outOfCombatTimestamp = 0
local isInCombat = false
local isInEncounter = false

-- Dynamic Anchor Logic
function CT:SetAnchor()
    if not self.frame then return end
    
    local anchorTo = E.UIParent
    local point, relativePoint = 'CENTER', 'CENTER'
    local x, y = 0, 0

    -- 1. Check Ayije Mana Frame
    if E.db.AYIJE and E.db.AYIJE.manaFrame and E.db.AYIJE.manaFrame.enable and _G.Ayije_ManaFrame then
        anchorTo = _G.Ayije_ManaFrame
        point, relativePoint = 'RIGHT', 'LEFT'
        x = -4
    -- 2. Check ElvUI Player Frame
    elseif E.db.unitframe and E.db.unitframe.units.player.enable and _G.ElvUF_Player then
        anchorTo = _G.ElvUF_Player
        point, relativePoint = 'RIGHT', 'LEFT'
        x = -4
    end

    self.frame:ClearAllPoints()
    self.frame:SetPoint(point, anchorTo, relativePoint, x, y)
end

function CT:CreateFrame()
    if not CombatTimerAnchor then
        CombatTimerAnchor = CreateFrame('Frame', 'CombatTimerAnchor', E.UIParent, 'BackdropTemplate')
        
        CombatTimerAnchor.text = CombatTimerAnchor:CreateFontString(nil, 'OVERLAY')
        CombatTimerAnchor.text:SetPoint('CENTER')
        CombatTimerAnchor.text:SetJustifyH('CENTER')
        CombatTimerAnchor.text:SetJustifyV('MIDDLE')
    end
    
    self.frame = CombatTimerAnchor
    self:SetAnchor()
    self:UpdateFont()
    self:UpdateSize()
    self.frame.text:SetText('')
end

function CT:UpdateFont()
    if not self.frame or not self.frame.text then return end
    -- Fix nil index error by falling back to P table
    local db = self.db or P.combatTimer
    local font = E.LSM:Fetch('font', db.font) or E.media.normFont
    local size = db.fontSize or 20
    local style = db.fontOutline or 'OUTLINE'
    self.frame.text:FontTemplate(font, size, style)
end

function CT:UpdateSize()
    if not self.frame then return end
    local db = self.db or P.combatTimer
    self.frame:SetSize(db.width, db.height)
end

function CT:OnUpdate()
    local timeInCombat = GetTime() - combatStartTime
    local seconds = floor(timeInCombat % 60)
    
    if seconds ~= self.lastSecond then
        local minutes = floor(timeInCombat / 60)
        self.frame.text:SetText(format('%02d:%02d', minutes, seconds))
        self.lastSecond = seconds
    end
end

function CT:OnEvent(event, ...)
    if event == 'PLAYER_REGEN_DISABLED' or event == 'ENCOUNTER_START' then
        local now = GetTime()
        if event == 'ENCOUNTER_START' then isInEncounter = true end
        
        if isInCombat and (now - outOfCombatTimestamp < 2) then
            local gap = now - outOfCombatTimestamp
            combatStartTime = combatStartTime + gap 
        else
            combatStartTime = now
            self.lastSecond = nil
            self.frame.text:SetText('00:00')
        end
        
        isInCombat = true
        self.frame.text:SetTextColor(1, 0.79, 0.03, 1)
        self.frame:Show()
        self.frame:SetScript('OnUpdate', function() self:OnUpdate() end)

    elseif event == 'PLAYER_REGEN_ENABLED' then
        if isInEncounter then return end
        
        outOfCombatTimestamp = GetTime()
        self.frame:SetScript('OnUpdate', nil)
        self.frame.text:SetTextColor(1, 1, 1, 0.4)
        
        C_Timer.After(2.1, function()
            if not InCombatLockdown() and not isInEncounter then
                isInCombat = false
            end
        end)

    elseif event == 'ENCOUNTER_END' then
        isInEncounter = false
        isInCombat = false
        self.frame:SetScript('OnUpdate', nil)
        self.frame.text:SetTextColor(1, 1, 1, 0.4)
        
        local total = GetTime() - combatStartTime
        self.frame.text:SetText(format('%02d:%02d', floor(total/60), floor(total%60)))
    end
end

function CT:Enable()
    if not self.frame then self:CreateFrame() end
    self.frame:Show()
    self:RegisterEvent('PLAYER_REGEN_DISABLED', 'OnEvent')
    self:RegisterEvent('PLAYER_REGEN_ENABLED', 'OnEvent')
    self:RegisterEvent('ENCOUNTER_START', 'OnEvent')
    self:RegisterEvent('ENCOUNTER_END', 'OnEvent')
end

function CT:Disable()
    if self.frame then
        self.frame:Hide()
        self.frame:SetScript('OnUpdate', nil)
    end
    self:UnregisterEvent('PLAYER_REGEN_DISABLED')
    self:UnregisterEvent('PLAYER_REGEN_ENABLED')
    self:UnregisterEvent('ENCOUNTER_START')
    self:UnregisterEvent('ENCOUNTER_END')
end

function CT:Initialize()
    -- Ensure db is always valid, falling back to Defaults
    self.db = E.db.combatTimer or P.combatTimer
    
    -- Always Enable
    self:Enable()
end

E:RegisterModule(CT:GetName())