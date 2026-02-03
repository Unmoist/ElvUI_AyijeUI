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
    [270] = { -- Monk (Mistweaver)
        secondary = {}, 
        tertiary  = {},
        colors = {

        }
    },
    [105] = { -- Druid (Restoration)
        secondary = {
            158478, 
            113043,
            }, 
        tertiary  = {
            1822, 
            1079,
            1261867,
        },
        colors = {
            [1822] = {0.99, 0.07, 0}, 
            [1079]  = {0.99, 0.07, 0},
            [1261867] = {0.99, 0.07, 0},
            [158478] = {0, 1, 0}, 
            [113043]  = {0, 0.75, 1},
        }
    },
}

---------------------------------------------------
-- 2. STATE
---------------------------------------------------
CDM.queue = {}
CDM.anchorContainers = {} -- Independent anchor containers: [viewerName] = containerFrame
CDM.anchorSlots = {} -- Stores anchor frames: [viewerName][spellID] = anchorFrame
CDM.slotOrder = {} -- Stores spellID order: [viewerName] = {spellID1, spellID2, ...}
CDM.isLocked = {} -- Track if viewer positions are locked: [viewerName] = true
CDM.isEditModeActive = false -- Track if Edit Mode is currently open

local Updater = CreateFrame("Frame")

local SECONDARY_SET, TERTIARY_SET = {}, {}
local tempBuff, tempSec, tempTert = {}, {}, {}
local tempEssential, tempUtility = {}, {}

local IsActiveCurve = C_CurveUtil.CreateCurve()
IsActiveCurve:SetType(Enum.LuaCurveType.Step)
IsActiveCurve:AddPoint(0, 0)
IsActiveCurve:AddPoint(0.0001, 1)

---------------------------------------------------
-- 3. HELPERS
---------------------------------------------------
local function GetSpellIDForAnchoring(frame)
    if not frame then return nil end

    local info = frame.cooldownInfo
    local spellID =
        info and (info.overrideSpellID or info.spellID)
        or (frame.GetSpellID and frame:GetSpellID())

    if not spellID then return nil end

    -- Try to get base spell ID, but if it returns the same ID, use raw ID
    -- This handles both cases: spells with base IDs and spells without
    local baseSpellID = C_Spell.GetBaseSpell(spellID)
    
    -- If baseSpellID is different from spellID, use the base (shapeshifting spells)
    -- If they're the same or base is nil, use raw spellID (Nature's Cure variants)
    if baseSpellID and baseSpellID ~= spellID then
        return baseSpellID
    else
        return spellID
    end
end

local function GetBaseSpellID(frame)
    if not frame then return nil end

    local info = frame.cooldownInfo
    local spellID =
        info and (info.overrideSpellID or info.spellID)
        or (frame.GetSpellID and frame:GetSpellID())

    if not spellID then return nil end

    local baseSpellID = C_Spell.GetBaseSpell(spellID)
    return baseSpellID or spellID
end


function CDM:RefreshSpecData()
    table.wipe(SECONDARY_SET)
    table.wipe(TERTIARY_SET)

    local specIndex = GetSpecialization()
    local specInfo = specIndex and GetSpecializationInfo(specIndex)
    local data = SPELL_REGISTRY[specInfo]
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

---------------------------------------------------
-- 4. ANCHOR SLOT SYSTEM
---------------------------------------------------
function CDM:GetOrCreateAnchorContainer(viewer)
    local vName = viewer:GetName()
    
    if self.anchorContainers[vName] then
        return self.anchorContainers[vName]
    end
    
    -- Create independent container frame parented to UIParent, not the viewer
    local container = CreateFrame("Frame", vName .. "_AnchorContainer", UIParent)
    container:SetFrameStrata(viewer:GetFrameStrata())
    container:SetFrameLevel(viewer:GetFrameLevel())
    
    -- Store last known position to detect changes
    local lastPoint, lastX, lastY
    
    -- Function to update container position to match viewer
    local function UpdateContainerPosition()
        if not viewer or not viewer.GetPoint then return end
        
        local point, relativeTo, relativePoint, xOfs, yOfs = viewer:GetPoint()
        if point and (point ~= lastPoint or xOfs ~= lastX or yOfs ~= lastY) then
            container:ClearAllPoints()
            container:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
            container:SetSize(viewer:GetSize())
            lastPoint = point
            lastX = xOfs
            lastY = yOfs
        end
    end
    
    -- Initial position
    UpdateContainerPosition()
    
    -- Keep container synchronized with viewer position
    container:SetScript("OnUpdate", UpdateContainerPosition)
    
    self.anchorContainers[vName] = container
    return container
end

function CDM:LockIconPositions(icons, viewer, vName)
    if #icons == 0 then return end
    
    -- Sort by layoutIndex to get the correct order from Cooldown Manager
    table.sort(icons, function(a, b)
        return (a.layoutIndex or 0) < (b.layoutIndex or 0)
    end)
    
    -- Store the order using smart spell ID detection
    if not self.slotOrder[vName] then
        self.slotOrder[vName] = {}
    end
    table.wipe(self.slotOrder[vName])
    
    for i, frame in ipairs(icons) do
        local spellID = GetSpellIDForAnchoring(frame)
        if spellID then
            table.insert(self.slotOrder[vName], spellID)
        end
    end
    
    -- Now create anchor slots based on this locked order
    self:CreateAnchorSlots(viewer, vName)
end

function CDM:CreateAnchorSlots(viewer, vName)
    local container = self:GetOrCreateAnchorContainer(viewer)
    
    if not self.anchorSlots[vName] then
        self.anchorSlots[vName] = {}
    end
    
    local order = self.slotOrder[vName]
    if not order or #order == 0 then return end
    
    local maxPerRow = (vName == VIEWERS.ESSENTIAL) and MAX_ROW_ESS or #order
    
    for i, spellID in ipairs(order) do
        -- Skip if anchor already exists for this spellID
        if not self.anchorSlots[vName][spellID] then
            local row = math.ceil(i / maxPerRow)
            local col = (i - 1) % maxPerRow
            local countInRow = math.min(maxPerRow, #order - (row - 1) * maxPerRow)
            
            local totalWidth = (countInRow * SIZE_COOLDOWN.w) + ((countInRow - 1) * SPACING)
            local startX = -(totalWidth / 2) + (SIZE_COOLDOWN.w / 2)
            local x = startX + (col * (SIZE_COOLDOWN.w + SPACING))
            local y = -(row - 1) * (SIZE_COOLDOWN.h + SPACING)
            
            -- Create anchor in the independent container
            local anchor = CreateFrame("Frame", nil, container)
            anchor:SetSize(SIZE_COOLDOWN.w, SIZE_COOLDOWN.h)
            anchor:SetPoint("TOP", container, "TOP", x, y)
            
            self.anchorSlots[vName][spellID] = anchor
        end
    end
end

---------------------------------------------------
-- 5. AURA ENGINE
---------------------------------------------------
function CDM:ApplyAuraState(frame, spellID)
    if not frame or not frame.Cooldown then return end

    local cdInfo = C_Spell.GetSpellCooldown(spellID)
    local isOnGCD = cdInfo and cdInfo.isOnGCD
    local tex = frame.icon or frame.Icon

    if tex then
        local durObj = not isOnGCD and C_Spell.GetSpellCooldownDuration(spellID)
        tex:SetDesaturation(
            durObj and durObj:EvaluateRemainingDuration(IsActiveCurve, 0) or 0
        )
    end

    frame.isUpdatingCD = true

    if isOnGCD then
        frame.Cooldown:SetCooldown(cdInfo.startTime, cdInfo.duration)
    else
        local durObj = C_Spell.GetSpellChargeDuration(spellID)
            or C_Spell.GetSpellCooldownDuration(spellID)

        if durObj then
            frame.Cooldown:SetCooldownFromDurationObject(durObj)
        else
            frame.Cooldown:Clear()
        end
    end

    frame.isUpdatingCD = false

    if frame.Cooldown.SetSwipeColor then
        frame.Cooldown:SetSwipeColor(0, 0, 0, 0.6)
    end

    local glow = frame.SpellActivationAlert
    if glow then
        glow:SetFrameLevel(frame:GetFrameLevel() + 10)
    end
end

function CDM:ProcessAuraOverride(frame)
    if not frame or frame.isUpdatingCD then return end
    local spellID = GetBaseSpellID(frame)
    if spellID then
        self:ApplyAuraState(frame, spellID)
    end
end

---------------------------------------------------
-- 6. STYLING
---------------------------------------------------
function CDM:ApplyStyle(frame, vName)
    if not frame or frame.hooksInitialized then return end

    local isBuff =
        vName == VIEWERS.BUFF
        or vName == VIEWERS.BUFF_SEC
        or vName == VIEWERS.BUFF_TERT

    frame:SetSize(
        isBuff and SIZE_BUFF.w or SIZE_COOLDOWN.w,
        isBuff and SIZE_BUFF.h or SIZE_COOLDOWN.h
    )

    if isBuff and frame.Cooldown then
        frame.Cooldown:SetReverse(true)
    end    

    if isBuff and frame.Applications then
        local apps = frame.Applications
        apps:ClearAllPoints()
        apps:SetSize(SIZE_BUFF.w, SIZE_BUFF.h)
        apps:SetFrameLevel(frame:GetFrameLevel() + 3)
        if vName == VIEWERS.BUFF then
            apps:SetPoint("BOTTOM", frame, "TOP", -10, -12)
        end

        if vName == VIEWERS.BUFF_SEC then
            apps:SetPoint("RIGHT", frame, "LEFT", -6, 6)
        end  

        if vName == VIEWERS.BUFF_TERT then
            apps:SetPoint("LEFT", frame, "RIGHT", 2, 6)
        end
    end

    if not frame.borderFrame then
        frame.borderFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        frame.borderFrame:SetAllPoints()
        if BORDER and BORDER.CreateBorder then
            BORDER:CreateBorder(frame.borderFrame)
        end
    end

    if isBuff then
        frame.DebuffBorder.Texture:SetAlpha(0)

        local borderColor = frame.borderFrame.border
        if borderColor.SetBackdropBorderColor then
        local spellID = GetBaseSpellID(frame)
        local specIndex = GetSpecialization()
        local specInfo = specIndex and GetSpecializationInfo(specIndex)
        
        -- Default Fallback
        local r, g, b = 1, 1, 1
        
        -- Check if current spec has a specific color for this spell
        local data = SPELL_REGISTRY[specInfo]
        if data and data.colors and data.colors[spellID] then
            r, g, b = unpack(data.colors[spellID])
        end
        
        borderColor:SetBackdropBorderColor(r, g, b, 1)
        end
    end
    
    if VIEWERS_WITH_OVERRIDE[vName] then
        local tex = frame.icon or frame.Icon
        if tex then
            hooksecurefunc(tex, "SetDesaturated", function()
                self:ProcessAuraOverride(frame)
            end)
        end
        if frame.Cooldown then
            hooksecurefunc(frame.Cooldown, "SetCooldown", function()
                self:ProcessAuraOverride(frame)
            end)
        end
    end
    frame.hooksInitialized = true
end

---------------------------------------------------
-- 7. LAYOUT ENGINE
---------------------------------------------------
local function PositionIconsInStack(icons, container, size, cdm, vName, prioritySet)
    if #icons == 0 then return end

    -- Sort by registry order for Secondary/Tertiary
    table.sort(icons, function(a, b)
        local aID, bID = GetBaseSpellID(a), GetBaseSpellID(b)
        return (prioritySet[aID] or 99) < (prioritySet[bID] or 99)
    end)

    for i, frame in ipairs(icons) do
        cdm:ApplyStyle(frame, vName)
        frame:ClearAllPoints()
        frame:SetParent(container)
        -- Stack from bottom to top
        frame:SetPoint("BOTTOM", container, "BOTTOM", 0, (i - 1) * (size.h + SPACING))
    end
end

function CDM:PositionEssentialOrUtilityIcons(icons, viewer, vName)
    if #icons == 0 then return end
    
    -- Don't lock if Edit Mode is active
    if not self.isEditModeActive and not self.isLocked[vName] then
        -- First time: lock the order and create anchor slots
        self:LockIconPositions(icons, viewer, vName)
        self.isLocked[vName] = true
        print("|cff00da48[CDM] Locked positions for " .. vName .. " with " .. #icons .. " icons|r")
    end
    
    -- If we're locked, use anchor slots. Otherwise let Blizzard handle it (Edit Mode)
    if self.isLocked[vName] and not self.isEditModeActive then
        -- Position each icon to its designated anchor slot using smart spell ID detection
        for _, frame in ipairs(icons) do
            local spellID = GetSpellIDForAnchoring(frame)
            if spellID then
                local anchor = self.anchorSlots[vName] and self.anchorSlots[vName][spellID]
                
                if anchor then
                    -- Apply styling
                    self:ApplyStyle(frame, vName)
                    
                    -- Position to the locked anchor slot
                    frame:ClearAllPoints()
                    frame:SetParent(UIParent) -- Important: parent to UIParent, not viewer
                    frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)
                    
                    -- Apply override logic
                    if VIEWERS_WITH_OVERRIDE[vName] then
                        self:ProcessAuraOverride(frame)
                    end
                end
                -- Note: Not logging missing anchors as they can be temporary during loading/spec changes
            end
        end
    else
        -- Edit Mode is active - reparent icons back to viewer and let Blizzard position them
        for _, frame in ipairs(icons) do
            self:ApplyStyle(frame, vName)
            
            -- Reparent back to viewer so it has proper size for Edit Mode
            frame:SetParent(viewer)
            
            if VIEWERS_WITH_OVERRIDE[vName] then
                self:ProcessAuraOverride(frame)
            end
        end
    end
end

function CDM:ForceReanchor(viewer)
    if not viewer or not viewer:IsShown() then return end

    local vName = viewer:GetName()
    table.wipe(tempBuff)
    table.wipe(tempSec)
    table.wipe(tempTert)
    table.wipe(tempEssential)
    table.wipe(tempUtility)

    -- 1. Collect Icons from the pool
    if viewer.itemFramePool then
        for frame in viewer.itemFramePool:EnumerateActive() do
            if frame:IsShown() then
                local id = GetBaseSpellID(frame)
                
                if vName == VIEWERS.ESSENTIAL then
                    table.insert(tempEssential, frame)
                elseif vName == VIEWERS.UTILITY then
                    table.insert(tempUtility, frame)
                elseif vName == VIEWERS.BUFF then
                    -- Split buffs into main/secondary/tertiary
                    if id and TERTIARY_SET[id] then
                        table.insert(tempTert, frame)
                    elseif id and SECONDARY_SET[id] then
                        table.insert(tempSec, frame)
                    else
                        table.insert(tempBuff, frame)
                    end
                end
            end
        end
    end

    -- 2. Position based on viewer type
    if vName == VIEWERS.ESSENTIAL then
        self:PositionEssentialOrUtilityIcons(tempEssential, viewer, vName)
        
    elseif vName == VIEWERS.UTILITY then
        self:PositionEssentialOrUtilityIcons(tempUtility, viewer, vName)
        
    elseif vName == VIEWERS.BUFF then
        -- Position Secondary/Tertiary Stacks (Registry Order)
        PositionIconsInStack(tempSec, self.secBuffs, SIZE_BUFF, self, VIEWERS.BUFF_SEC, SECONDARY_SET)
        PositionIconsInStack(tempTert, self.tertBuffs, SIZE_BUFF, self, VIEWERS.BUFF_TERT, TERTIARY_SET)
        
        -- Position Main Buff Group (Grid Layout)
        if #tempBuff > 0 then
            -- Sort by Blizzard's layoutIndex
            table.sort(tempBuff, function(a, b)
                return (a.layoutIndex or 0) < (b.layoutIndex or 0)
            end)
            
            local maxPerRow = #tempBuff
            
            for i, frame in ipairs(tempBuff) do
                self:ApplyStyle(frame, vName)

                local row = math.ceil(i / maxPerRow)
                local col = (i - 1) % maxPerRow
                local countInRow = math.min(maxPerRow, #tempBuff - (row - 1) * maxPerRow)

                local totalWidth = (countInRow * SIZE_BUFF.w) + ((countInRow - 1) * SPACING)
                local startX = -(totalWidth / 2) + (SIZE_BUFF.w / 2)
                local x = startX + (col * (SIZE_BUFF.w + SPACING))

                frame:ClearAllPoints()
                frame:SetParent(viewer)
                frame:SetPoint("TOP", viewer, "TOP", x, -(row - 1) * (SIZE_BUFF.h + SPACING))
            end
        end
    end
end

---------------------------------------------------
-- 8. BLIZZARD LAYOUT HOOK
---------------------------------------------------
local function HookViewerLayout(viewer, name)
    if viewer.__CDMLayoutHooked then return end
    viewer.__CDMLayoutHooked = true

    if viewer.UpdateLayout then
        hooksecurefunc(viewer, "UpdateLayout", function()
            CDM:QueueViewer(name, true)
        end)
    elseif viewer.Layout then
        hooksecurefunc(viewer, "Layout", function()
            CDM:QueueViewer(name, true)
        end)
    end
end

---------------------------------------------------
-- 9. QUEUE PROCESSOR
---------------------------------------------------
local function QueueProcessor()
    if not next(CDM.queue) then
        Updater:SetScript("OnUpdate", nil)
        return
    end

    for name in pairs(CDM.queue) do
        local v = _G[name]
        if v then
            CDM:ForceReanchor(v)
        end
        CDM.queue[name] = nil
    end
end

function CDM:QueueViewer(name, immediate)
    if immediate then
        local v = _G[name]
        if v then
            self:ForceReanchor(v)
        end
    else
        self.queue[name] = true
        if not Updater:GetScript("OnUpdate") then
            Updater:SetScript("OnUpdate", QueueProcessor)
        end
    end
end

function CDM:QueueAllViewers(immediate)
    for _, vName in ipairs({
        VIEWERS.ESSENTIAL,
        VIEWERS.UTILITY,
        VIEWERS.BUFF,
    }) do
        self:QueueViewer(vName, immediate)
    end
end

---------------------------------------------------
-- 10. INITIALIZATION
---------------------------------------------------
function CDM:SetupViewer(vName)
    local v = _G[vName]
    if not v or v.isHookedByCDM then return end

    v.isHookedByCDM = true
    HookViewerLayout(v, vName)

    if v.itemFramePool then
        hooksecurefunc(v.itemFramePool, "Acquire", function()
            self:QueueViewer(vName)
        end)
    end

    v:HookScript("OnShow", function()
        self:QueueViewer(vName)
    end)

    self:QueueViewer(vName)
end

function CDM:Initialize()
    local mainBuffs = _G[VIEWERS.BUFF]
    if mainBuffs then
        self.secBuffs = CreateFrame("Frame", VIEWERS.BUFF_SEC, UIParent)
        self.secBuffs:SetPoint("BOTTOM", mainBuffs, "TOP", 120, 6)
        self.secBuffs:SetSize(SIZE_BUFF.w, 400)
        self.secBuffs:Show()

        self.tertBuffs = CreateFrame("Frame", VIEWERS.BUFF_TERT, UIParent)
        self.tertBuffs:SetPoint("BOTTOM", mainBuffs, "TOP", -120, 6)
        self.tertBuffs:SetSize(SIZE_BUFF.w, 400)
        self.tertBuffs:Show()
    end

    if EditModeManagerFrame then
        EditModeManagerFrame:HookScript("OnShow", function()
            -- Set Edit Mode flag and release locks
            print("|cff00da48[CDM] Edit Mode opened - releasing all locks|r")
            self.isEditModeActive = true
            self.isLocked = {}
            
            -- Force reanchor to reparent icons back to viewer before Edit Mode fully loads
            self:QueueAllViewers(true)
            
            -- Give Blizzard a moment to process the reparenting, then force layout update
            C_Timer.After(0.05, function()
                for _, vName in ipairs({VIEWERS.ESSENTIAL, VIEWERS.UTILITY}) do
                    local viewer = _G[vName]
                    if viewer and viewer.UpdateLayout then
                        viewer:UpdateLayout()
                    elseif viewer and viewer.Layout then
                        viewer:Layout()
                    end
                end
            end)
        end)
        
        hooksecurefunc(EditModeManagerFrame, "ExitEditMode", function()
            -- Clear Edit Mode flag and clear everything to re-lock with new positions
            print("|cff00da48[CDM] Edit Mode closed - will re-lock positions|r")
            self.isEditModeActive = false
            self.anchorContainers = {}
            self.anchorSlots = {}
            self.slotOrder = {}
            self.isLocked = {}
            
            -- Delay re-locking to ensure viewer has settled into its final position
            C_Timer.After(0.2, function()
                self:QueueAllViewers(true)
            end)
        end)
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD", function(event, isInitialLogin, isReloadingUi)
        self:RefreshSpecData()
        
        -- Only reset lock status on actual login/reload, NOT on zone changes
        if isInitialLogin or isReloadingUi then
            print("|cff00da48[CDM] Initial login or reload detected - resetting lock status|r")
            self.isLocked = {}
            self.anchorContainers = {}
            self.anchorSlots = {}
            self.slotOrder = {}
        else
            print("|cff00da48[CDM] Zone change detected - keeping existing locks|r")
        end
        
        C_Timer.After(1.5, function()
            for _, n in ipairs({
                VIEWERS.ESSENTIAL,
                VIEWERS.UTILITY,
                VIEWERS.BUFF,
            }) do
                self:SetupViewer(n)
            end
            self:QueueAllViewers(true)
        end)
    end)

    -- Removed PLAYER_SPECIALIZATION_CHANGED for now to test single spec

    self:RegisterEvent("SPELL_UPDATE_COOLDOWN", function()
        self:QueueAllViewers()
    end)
end

E:RegisterModule(CDM:GetName())