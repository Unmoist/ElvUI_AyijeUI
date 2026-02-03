local AddonName, Engine = ...
local E = unpack(ElvUI)
local _G = _G

local CDM = E:NewModule("Ayije_CDM", "AceHook-3.0", "AceEvent-3.0")
local BORDER = E:GetModule("BORDER")

---------------------------------------------------
-- 1. CONFIG & CONSTANTS
---------------------------------------------------
local SIZE_COOLDOWN = { w = 46, h = 40 }
local SIZE_BUFF     = { w = 40, h = 36 }
local SPACING       = 6
local MAX_ROW_ESS   = 8

local VIEWERS = {
    ESSENTIAL = "EssentialCooldownViewer",
    UTILITY   = "UtilityCooldownViewer",
    BUFF      = "BuffIconCooldownViewer",
    BUFF_SEC  = "BuffIconCooldownViewer_Secondary",
    BUFF_TERT = "BuffIconCooldownViewer_Tertiary",
}

local VIEWERS_WITH_OVERRIDE = {
    [VIEWERS.ESSENTIAL] = true,
    [VIEWERS.UTILITY]   = true,
}

local SPELL_REGISTRY = {
    [270] = { secondary = {1266735,1266734,115203}, tertiary = {116841} }, -- Mistweaver Monk
    [105] = { secondary = {158478,113043}, tertiary = {1822,1079} },        -- Restoration Druid
}

---------------------------------------------------
-- 2. STATE
---------------------------------------------------
CDM.queue = {}
local Updater = CreateFrame("Frame")

local SECONDARY_SET, TERTIARY_SET = {}, {}
local tempMain, tempSec, tempTert = {}, {}, {}

-- Step curve for cooldown desaturation
local IsActiveCurve = C_CurveUtil.CreateCurve()
IsActiveCurve:SetType(Enum.LuaCurveType.Step)
IsActiveCurve:AddPoint(0, 0)
IsActiveCurve:AddPoint(0.0001, 1)

---------------------------------------------------
-- 3. HELPERS
---------------------------------------------------
local function GetSpellID(frame)
    if not frame then return nil end
    local info = frame.cooldownInfo
    return info and (info.overrideSpellID or info.spellID) or (frame.GetSpellID and frame:GetSpellID())
end

function CDM:RefreshSpecData()
    table.wipe(SECONDARY_SET)
    table.wipe(TERTIARY_SET)

    local specInfo = GetSpecialization() and GetSpecializationInfo(GetSpecialization())
    local data = SPELL_REGISTRY[specInfo]
    if not data then return end

    if data.secondary then
        for i, id in ipairs(data.secondary) do SECONDARY_SET[id] = i end
    end
    if data.tertiary then
        for i, id in ipairs(data.tertiary) do TERTIARY_SET[id] = i end
    end
end

---------------------------------------------------
-- 4. AURA ENGINE
---------------------------------------------------
function CDM:ApplyAuraState(frame, spellID)
    if not frame or not frame.Cooldown then return end
    
    local cdInfo = C_Spell.GetSpellCooldown(spellID)
    local isOnGCD = cdInfo and cdInfo.isOnGCD
    local tex = frame.icon or frame.Icon

    -- 1. Handle Desaturation
    if tex then
        -- We only desaturate if NOT on GCD, otherwise use the regular cooldown durObj
        local durObj = not isOnGCD and C_Spell.GetSpellCooldownDuration(spellID)
        tex:SetDesaturation(durObj and durObj:EvaluateRemainingDuration(IsActiveCurve, 0) or 0)
    end

    -- 2. Handle Cooldown Swipe
    frame.isUpdatingCD = true -- Prevent recursive hook calls
    if isOnGCD then
        frame.Cooldown:SetCooldown(cdInfo.startTime, cdInfo.duration)
    else
        local durObj = C_Spell.GetSpellChargeDuration(spellID) or C_Spell.GetSpellCooldownDuration(spellID)
        if durObj then 
            frame.Cooldown:SetCooldownFromDurationObject(durObj) 
        else 
            frame.Cooldown:Clear() 
        end
    end
    frame.isUpdatingCD = false

    -- 3. Visual Polish
    if frame.Cooldown.SetSwipeColor then frame.Cooldown:SetSwipeColor(0, 0, 0, 0.6) end
    local glow = frame.SpellActivationAlert
    if glow then glow:SetFrameLevel(frame:GetFrameLevel() + 10) end
end

function CDM:ProcessAuraOverride(frame)
    if not frame or frame.isUpdatingCD then return end
    local spellID = GetSpellID(frame)
    if not spellID then return end

    self:ApplyAuraState(frame, spellID)
end

---------------------------------------------------
-- 5. STYLING
---------------------------------------------------
function CDM:ApplyStyle(frame, vName)
    if not frame or frame.hooksInitialized then return end

    local isBuff = (vName == VIEWERS.BUFF or vName == VIEWERS.BUFF_SEC or vName == VIEWERS.BUFF_TERT)
    local hasOverride = VIEWERS_WITH_OVERRIDE[vName]

    frame:SetSize(isBuff and SIZE_BUFF.w or SIZE_COOLDOWN.w, isBuff and SIZE_BUFF.h or SIZE_COOLDOWN.h)
    if isBuff and frame.Cooldown then frame.Cooldown:SetReverse(true) end

    if hasOverride then
        local tex = frame.icon or frame.Icon
        -- Hooking SetDesaturated is tricky; we use it to catch when the game tries to grey it out
        if tex then hooksecurefunc(tex, "SetDesaturated", function() self:ProcessAuraOverride(frame) end) end
        if frame.Cooldown then hooksecurefunc(frame.Cooldown, "SetCooldown", function() self:ProcessAuraOverride(frame) end) end
    end

    if not frame.borderFrame then
        frame.borderFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        frame.borderFrame:SetAllPoints()
        if BORDER and BORDER.CreateBorder then BORDER:CreateBorder(frame.borderFrame) end
    end

    frame.hooksInitialized = true
end

---------------------------------------------------
-- 6. LAYOUT ENGINE
---------------------------------------------------
local function PositionIconsInStack(icons, container, size, cdm, vName, prioritySet)
    if #icons == 0 then return end

    table.sort(icons, function(a,b)
        return (prioritySet[GetSpellID(a)] or 99) < (prioritySet[GetSpellID(b)] or 99)
    end)

    for i, frame in ipairs(icons) do
        cdm:ApplyStyle(frame, vName)
        frame:ClearAllPoints()
        frame:SetParent(container)
        frame:SetPoint("BOTTOM", container, "BOTTOM", 0, (i-1)*(size.h+SPACING))
    end
end

function CDM:ForceReanchor(viewer)
    if not viewer or not viewer:IsShown() then return end

    local vName = viewer:GetName()
    table.wipe(tempMain); table.wipe(tempSec); table.wipe(tempTert)

    if vName == VIEWERS.BUFF and viewer.itemFramePool then
        for frame in viewer.itemFramePool:EnumerateActive() do
            if frame:IsShown() then
                local id = GetSpellID(frame)
                if id and TERTIARY_SET[id] then table.insert(tempTert, frame)
                elseif id and SECONDARY_SET[id] then table.insert(tempSec, frame)
                else table.insert(tempMain, frame) end
            end
        end
    else
        for _, frame in ipairs({viewer:GetChildren()}) do
            if frame:IsShown() and (frame.Icon or frame.Cooldown) then table.insert(tempMain, frame) end
        end
    end

    if vName == VIEWERS.BUFF then
        PositionIconsInStack(tempSec, self.secBuffs, SIZE_BUFF, self, VIEWERS.BUFF_SEC, SECONDARY_SET)
        PositionIconsInStack(tempTert, self.tertBuffs, SIZE_BUFF, self, VIEWERS.BUFF_TERT, TERTIARY_SET)
    end

    if #tempMain == 0 then return end
    table.sort(tempMain, function(a,b) return (a.layoutIndex or 0) < (b.layoutIndex or 0) end)

    local size = (vName == VIEWERS.BUFF) and SIZE_BUFF or SIZE_COOLDOWN
    local maxPerRow = (vName == VIEWERS.ESSENTIAL) and MAX_ROW_ESS or #tempMain
    local hasOverride = VIEWERS_WITH_OVERRIDE[vName]

    for i, frame in ipairs(tempMain) do
        self:ApplyStyle(frame, vName)

        local row, col = math.ceil(i / maxPerRow), (i-1) % maxPerRow
        local countInRow = math.min(maxPerRow, #tempMain - (row-1)*maxPerRow)
        local x = -(((countInRow*size.w) + ((countInRow-1)*SPACING) - size.w)/2) + (col*(size.w+SPACING))

        frame:ClearAllPoints()
        frame:SetParent(viewer)
        frame:SetPoint("TOP", viewer, "TOP", x, -(row-1)*(size.h+SPACING))

        if hasOverride then self:ProcessAuraOverride(frame) end
    end
end

---------------------------------------------------
-- 7. QUEUE PROCESSOR
---------------------------------------------------
local function QueueProcessor()
    if not next(CDM.queue) then 
        Updater:SetScript("OnUpdate", nil) 
        return 
    end

    for name in pairs(CDM.queue) do
        local v = _G[name]
        if v then CDM:ForceReanchor(v) end
        CDM.queue[name] = nil
    end
end

function CDM:QueueViewer(name, immediate)
    if immediate then
        local v = _G[name]
        if v then self:ForceReanchor(v) end
    else
        self.queue[name] = true
        if not Updater:GetScript("OnUpdate") then
            Updater:SetScript("OnUpdate", QueueProcessor)
        end
    end
end

function CDM:QueueAllViewers(immediate)
    for _, vName in ipairs({VIEWERS.ESSENTIAL, VIEWERS.UTILITY, VIEWERS.BUFF}) do
        self:QueueViewer(vName, immediate)
    end
end

---------------------------------------------------
-- 8. INITIALIZATION
---------------------------------------------------
function CDM:SetupViewer(vName)
    local v = _G[vName]
    if not v or v.isHookedByCDM then return end
    v.isHookedByCDM = true

    if v.itemFramePool then
        hooksecurefunc(v.itemFramePool, "Acquire", function()
            self:QueueViewer(vName)
        end)
    end

    v:HookScript("OnShow", function() self:QueueViewer(vName) end)
    self:QueueViewer(vName)
end

function CDM:Initialize()
    local mainBuffs = _G[VIEWERS.BUFF]
    if mainBuffs then
        self.secBuffs = CreateFrame("Frame", VIEWERS.BUFF_SEC, UIParent)
        self.secBuffs:SetPoint("BOTTOM", mainBuffs, "TOP", 120, 6)
        self.secBuffs:SetSize(SIZE_BUFF.w, 400); self.secBuffs:Show()

        self.tertBuffs = CreateFrame("Frame", VIEWERS.BUFF_TERT, UIParent)
        self.tertBuffs:SetPoint("BOTTOM", mainBuffs, "TOP", -120, 6)
        self.tertBuffs:SetSize(SIZE_BUFF.w, 400); self.tertBuffs:Show()
    end

    if EditModeManagerFrame then
        EditModeManagerFrame:HookScript("OnShow", function() self:QueueAllViewers(true) end)
        hooksecurefunc(EditModeManagerFrame, "ExitEditMode", function() self:QueueAllViewers(true) end)
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        self:RefreshSpecData()
        C_Timer.After(1, function()
            for _, n in ipairs({VIEWERS.ESSENTIAL, VIEWERS.BUFF, VIEWERS.UTILITY}) do
                self:SetupViewer(n)
            end
            self:QueueAllViewers(true)
        end)
    end)

    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", function()
        self:RefreshSpecData()
        self:QueueAllViewers()
    end)

    self:RegisterEvent("SPELL_UPDATE_COOLDOWN", function()
        self:QueueAllViewers()
    end)
end

E:RegisterModule(CDM:GetName())