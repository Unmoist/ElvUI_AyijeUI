local AddonName, Engine = ...

local E = unpack(ElvUI)
local _G = _G

local CDM = E:NewModule("Ayije_CDM", "AceHook-3.0", "AceEvent-3.0")
local BORDER = E:GetModule("BORDER")

---------------------------------------------------
-- 1. CONFIGURATION
---------------------------------------------------

local overrideAura = true

local SIZE_COOLDOWN = { w = 46, h = 40 }
local SIZE_BUFF     = { w = 40, h = 36 }

local SPACING = 6
local MAX_PER_ROW_ESSENTIAL = 8

---------------------------------------------------
-- 2. SPELL REGISTRY
---------------------------------------------------

local SPELL_REGISTRY = {
    [270] = { -- Mistweaver Monk
        secondary = {
            1266735, -- Sheilun's Gift (Celestial)
            1266734, -- Invoke Chi-Ji (Celestial)
            115203,  -- Fortifying Brew
        },
        tertiary = {
            116841,  -- Tiger's Lust
        },
    },

    [105] = { -- Restoration Druid
        secondary = {
            158478, -- Soul of the Forest
            113043, -- Omen of Clarity
        },
        tertiary = {
            1822, -- Rake
            1079, -- Rip
        },
    },
}

local SECONDARY_SET = {}
local TERTIARY_SET  = {}

---------------------------------------------------
-- 3. VIEWERS
---------------------------------------------------

local VIEWER_ESSENTIAL = "EssentialCooldownViewer"
local VIEWER_UTILITY   = "UtilityCooldownViewer"
local VIEWER_BUFF      = "BuffIconCooldownViewer"
local VIEWER_BUFF_SEC  = "BuffIconCooldownViewer_Secondary"
local VIEWER_BUFF_TERT = "BuffIconCooldownViewer_Tertiary"

local VIEWERS_WITH_OVERRIDE = {
    [VIEWER_ESSENTIAL] = true,
    [VIEWER_UTILITY]   = true,
}

---------------------------------------------------
-- 4. MODULE STATE
---------------------------------------------------

CDM.updater   = CreateFrame("Frame")
CDM.queue     = {}
CDM.iconOrder = {} -- viewer -> frame -> index

local tempMain, tempSec, tempTert = {}, {}, {}

---------------------------------------------------
-- 5. CURVE
---------------------------------------------------

local IsActiveCurve = C_CurveUtil.CreateCurve()
IsActiveCurve:SetType(Enum.LuaCurveType.Step)
IsActiveCurve:AddPoint(0, 0)
IsActiveCurve:AddPoint(0.0001, 1)

---------------------------------------------------
-- 6. AURA STATE
---------------------------------------------------

CDM.AuraState = {
    READY    = 1,
    COOLDOWN = 2,
    GCD      = 3,
}

---------------------------------------------------
-- 7. HELPERS
---------------------------------------------------

local function GetSpellID(frame)
    if not frame then return nil end
    return frame.cooldownInfo
        and (frame.cooldownInfo.overrideSpellID or frame.cooldownInfo.spellID)
        or (frame.GetSpellID and frame:GetSpellID())
end

function CDM:RefreshSpecData()
    table.wipe(SECONDARY_SET)
    table.wipe(TERTIARY_SET)

    local specIndex = GetSpecialization()
    local specID = specIndex and GetSpecializationInfo(specIndex)
    local data = SPELL_REGISTRY[specID]
    if not data then return end

    if data.secondary then
        for i, id in ipairs(data.secondary) do
            SECONDARY_SET[id] = i
        end
    end

    if data.tertiary then
        for i, id in ipairs(data.tertiary) do
            TERTIARY_SET[id] = i
        end
    end
end

function CDM:ClearIconOrder()
    for viewer, map in pairs(self.iconOrder) do
        table.wipe(map)
    end
end

---------------------------------------------------
-- 8. COOLDOWN SNAPSHOT
---------------------------------------------------

local function GetCooldownSnapshot(spellID)
    if not spellID then return nil end

    local info = C_Spell.GetSpellCooldown(spellID)
    if not info then return nil end

    if info.isOnGCD then
        return CDM.AuraState.GCD, info
    end

    local durObj = C_Spell.GetSpellChargeDuration(spellID)
        or C_Spell.GetSpellCooldownDuration(spellID)

    if durObj then
        return CDM.AuraState.COOLDOWN, durObj
    end

    return CDM.AuraState.READY
end

function CDM:ApplyAuraState(frame, state, data)
    local tex = frame.icon or frame.Icon
    local cd  = frame.Cooldown

    if state == CDM.AuraState.READY then
        if tex then tex:SetDesaturation(0) end
        cd:Clear()
    elseif state == CDM.AuraState.GCD then
        cd:SetCooldown(data.startTime, data.duration)
        if tex then tex:SetDesaturation(0) end
    elseif state == CDM.AuraState.COOLDOWN then
        cd:SetCooldownFromDurationObject(data)
        if tex then
            tex:SetDesaturation(
                data:EvaluateRemainingDuration(IsActiveCurve, 0)
            )
        end
    end

    if cd.SetSwipeColor then
        cd:SetSwipeColor(0, 0, 0, 0.6)
    end

    local glow = frame.SpellActivationAlert
    if glow then
        glow:SetFrameLevel(frame:GetFrameLevel() + 10)
    end
end

---------------------------------------------------
-- 9. STYLE ENGINE
---------------------------------------------------

function CDM:ApplyStyle(frame, viewerName, hasOverride)
    if frame._ayijeStyled then return end
    frame._ayijeStyled = true

    local isBuff = viewerName == VIEWER_BUFF
               or viewerName == VIEWER_BUFF_SEC
               or viewerName == VIEWER_BUFF_TERT

    local size = isBuff and SIZE_BUFF or SIZE_COOLDOWN
    frame:SetSize(size.w, size.h)

    if isBuff and frame.Cooldown then
        frame.Cooldown:SetReverse(true)
    end

    if not frame.borderFrame then
        frame.borderFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        frame.borderFrame:SetAllPoints(frame)
        if BORDER and BORDER.CreateBorder then
            BORDER:CreateBorder(frame.borderFrame)
        end
    end
end

---------------------------------------------------
-- 10. ANCHOR ENGINE
---------------------------------------------------

local function SortByPriority(icons, prioritySet)
    table.sort(icons, function(a, b)
        return (prioritySet[GetSpellID(a)] or 99)
             < (prioritySet[GetSpellID(b)] or 99)
    end)
end

local function PositionStack(icons, container, size, viewerName, cdm)
    for i, frame in ipairs(icons) do
        frame:ClearAllPoints()
        frame:SetParent(container)
        frame:SetPoint("BOTTOM", container, "BOTTOM", 0, (i - 1) * (size.h + SPACING))
        cdm:ApplyStyle(frame, viewerName, false)
    end
end

function CDM:ForceReanchor(viewer)
    if not viewer or not viewer:IsShown() then return end
    local vName = viewer:GetName()

    table.wipe(tempMain)
    table.wipe(tempSec)
    table.wipe(tempTert)

    if viewer.itemFramePool then
        for frame in viewer.itemFramePool:EnumerateActive() do
            if frame:IsShown() then
                local spellID = GetSpellID(frame)
                frame._spellID = spellID
                frame._state, frame._cdData = GetCooldownSnapshot(spellID)

                if vName == VIEWER_BUFF then
                    if TERTIARY_SET[spellID] then
                        tempTert[#tempTert + 1] = frame
                    elseif SECONDARY_SET[spellID] then
                        tempSec[#tempSec + 1] = frame
                    else
                        tempMain[#tempMain + 1] = frame
                    end
                else
                    tempMain[#tempMain + 1] = frame
                end
            end
        end
    end

    if vName == VIEWER_BUFF then
        if self.secBuffs then
            SortByPriority(tempSec, SECONDARY_SET)
            PositionStack(tempSec, self.secBuffs, SIZE_BUFF, VIEWER_BUFF_SEC, self)
        end
        if self.tertBuffs then
            SortByPriority(tempTert, TERTIARY_SET)
            PositionStack(tempTert, self.tertBuffs, SIZE_BUFF, VIEWER_BUFF_TERT, self)
        end
    end

    if #tempMain == 0 then return end

    self.iconOrder[vName] = self.iconOrder[vName] or {}
    local orderMap = self.iconOrder[vName]

    -- Remove dead frames
    for frame in pairs(orderMap) do
        if not frame:IsShown() then orderMap[frame] = nil end
    end

    -- Sort by stored order or layoutIndex
    table.sort(tempMain, function(a, b)
        local ao, bo = orderMap[a], orderMap[b]
        if ao and bo then return ao < bo end
        if ao then return true end
        if bo then return false end
        return (a.layoutIndex or 0) < (b.layoutIndex or 0)
    end)

    for i, frame in ipairs(tempMain) do
        orderMap[frame] = orderMap[frame] or i
    end

    local size = (vName == VIEWER_BUFF) and SIZE_BUFF or SIZE_COOLDOWN
    local maxPerRow = (vName == VIEWER_ESSENTIAL) and MAX_PER_ROW_ESSENTIAL or #tempMain
    local totalRows = math.ceil(#tempMain / maxPerRow)
    local hasOverride = VIEWERS_WITH_OVERRIDE[vName]

    -- Final positioning & apply visuals in single pass
    for i, frame in ipairs(tempMain) do
        local row = math.ceil(i / maxPerRow)
        local col = (i - 1) % maxPerRow
        local count = (row == totalRows and #tempMain % maxPerRow ~= 0)
                      and (#tempMain % maxPerRow)
                      or maxPerRow

        local x = -(((count * size.w) + ((count - 1) * SPACING) - size.w) / 2)
                  + (col * (size.w + SPACING))

        frame:ClearAllPoints()
        frame:SetParent(viewer)
        frame:SetPoint("TOP", viewer, "TOP", x, -(row - 1) * (size.h + SPACING))

        self:ApplyStyle(frame, vName, hasOverride)
        if hasOverride then
            self:ApplyAuraState(frame, frame._state, frame._cdData)
        end
    end
end

---------------------------------------------------
-- 11. QUEUE PROCESSOR
---------------------------------------------------

local queuedViewers = {}

local function QueueProcessor(self)
    if not next(CDM.queue) then
        self:SetScript("OnUpdate", nil)
        return
    end

    table.wipe(queuedViewers)
    for name in pairs(CDM.queue) do
        queuedViewers[#queuedViewers + 1] = name
    end
    table.wipe(CDM.queue)

    for _, name in ipairs(queuedViewers) do
        local viewer = _G[name]
        if viewer then
            CDM:ForceReanchor(viewer)
        end
    end
end

function CDM:QueueViewer(name)
    self.queue[name] = true
    if not self.updater:GetScript("OnUpdate") then
        self.updater:SetScript("OnUpdate", QueueProcessor)
    end
end

function CDM:QueueAllViewers()
    self:QueueViewer(VIEWER_ESSENTIAL)
    self:QueueViewer(VIEWER_UTILITY)
    self:QueueViewer(VIEWER_BUFF)
end

---------------------------------------------------
-- 12. INITIALIZATION
---------------------------------------------------

function CDM:Initialize()
    local mainBuffs = _G[VIEWER_BUFF]

    if mainBuffs then
        self.secBuffs = CreateFrame("Frame", VIEWER_BUFF_SEC, UIParent)
        self.secBuffs:SetPoint("BOTTOM", mainBuffs, "TOP", 120, 6)
        self.secBuffs:SetSize(SIZE_BUFF.w, 400)

        self.tertBuffs = CreateFrame("Frame", VIEWER_BUFF_TERT, UIParent)
        self.tertBuffs:SetPoint("BOTTOM", mainBuffs, "TOP", -120, 6)
        self.tertBuffs:SetSize(SIZE_BUFF.w, 400)
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        self:RefreshSpecData()
        self:QueueAllViewers()
    end)

    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", function()
        self:RefreshSpecData()
        self:ClearIconOrder()
        self:QueueAllViewers()
    end)

    self:RegisterEvent("SPELL_UPDATE_COOLDOWN", function()
        self:QueueAllViewers()
    end)

end

E:RegisterModule(CDM:GetName())
