local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local UF = E:GetModule("UnitFrames")
local GetTime = GetTime
local gsub, strmatch = gsub, strmatch

local function BorderAndSeparator(f)
    if not f then return end

    local hasBorder = f.border and f.border:IsShown()
    local hasHealthBorder = f.Health and f.Health.border and f.Health.border:IsShown()
    local hasPowerBorder = f.Power and f.Power.border and f.Power.border:IsShown()
    local hasPowerSeparator = f.Power and f.Power.separator and f.Power.separator:IsShown()

    if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
        if hasBorder then f.border:Hide() end

        if f.Health and f.Health.backdrop and not f.Health.backdrop.border then
            BORDER:CreateBorder(f.Health.backdrop)
        end
    else
        if hasHealthBorder then f.Health.border:Hide() end

        if not hasBorder then
            BORDER:CreateBorder(f, 15)
        end
    end

    if f.USE_POWERBAR and (hasBorder or (f.Health and f.Health.backdrop and f.Health.backdrop.border)) then
        if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
            if f.Power and f.Power.backdrop and not hasPowerBorder then
                BORDER:CreateBorder(f.Power.backdrop)
            end
            if hasPowerSeparator then f.Power.separator:Hide() end
        else
            if f.Power and not hasPowerSeparator then
                BORDER:CreateSeparator(f.Power)
            end
            if hasPowerBorder then f.Power.border:Hide() end
        end
    end
end

function S:ElvUI_UnitFrames(_, unit)
    local frameName = gsub(E:StringTitle(unit), 't(arget)', 'T%1')
    local enabled = UF.db.units[unit].enable

    local config = E.db.AYIJE and E.db.AYIJE.border
    if not config then return end

    local f = UF[unit]
    if not f then return end

    if frameName == 'Player' and enabled and config.Player then
        BorderAndSeparator(f)
        if config.Playersep and f.Power and f.Power.separator then
            f.Power.separator:Show()
            f.Power.separator:SetIgnoreParentAlpha(false)
        elseif f.Power and f.Power.separator then
            f.Power.separator:Hide()
        end
    elseif frameName == 'Target' and enabled and config.Target then
        BorderAndSeparator(f)
        if config.Targetsep and f.Power and f.Power.separator then
            f.Power.separator:Show()
            f.Power.separator:SetIgnoreParentAlpha(false)
        elseif f.Power and f.Power.separator then
            f.Power.separator:Hide()
        end
    elseif frameName == 'TargetTarget' and enabled and config.TargetofTarget then
        BorderAndSeparator(f)
    elseif frameName == 'Focus' and enabled and config.Focus then
        BorderAndSeparator(f)
    elseif frameName == 'FocusTarget' and enabled and config.FocusTarget then
        BorderAndSeparator(f)
    elseif frameName == 'Pet' and enabled and config.Pet then
        BorderAndSeparator(f)
    elseif frameName == 'PetTarget' and enabled and config.PetTarget then
        BorderAndSeparator(f)
    elseif frameName == 'TargetTargetTarget' and enabled and config.TargetofTargetofTarget then
        BorderAndSeparator(f)
    end
end

function S:ElvUI_UnitFramesGroup(_, group, numGroup)
    local config = E.db.AYIJE and E.db.AYIJE.border
    if not config then return end

    for i = 1, numGroup do
        local unit = group .. i
        local enabled = UF.db.units[group].enable

        if unit == "boss"..i and enabled and config.Boss and E.db.unitframe.units.boss.enable then
            local BF = _G["ElvUF_Boss"..i]
            BorderAndSeparator(BF)
            if BF.Power and BF.Power.separator then
                BF.Power.separator:SetIgnoreParentAlpha(false)
            end
            if BF.border then
                BF.border:SetFrameLevel(22)
            end
        end

        if unit == "arena"..i and enabled and config.Arena and E.db.unitframe.units.arena.enable then
            local AF = _G["ElvUF_Arena"..i]
            BorderAndSeparator(AF)
        end
    end
end

function S:ElvUI_UnitFramesGroupRaidParty(_, group)
    local db = UF.db.units[group]
    local config = E.db.AYIJE and E.db.AYIJE.border
    if not config then return end

    if not db or not db.enable then return end

    local name = E:StringTitle(group)
    if name == "Tank" and config.Maintankofftank then
        for i = 1, 2 do
            local f = _G["ElvUF_TankUnitButton"..i]
            BorderAndSeparator(f)
        end
    elseif name == "Assist" and config.AssistUnits then
        for i = 1, 2 do
            local f = _G["ElvUF_AssistUnitButton"..i]
            BorderAndSeparator(f)
        end
    end
end

function S:ElvUI_UnitFrames_PostUpdateAura(uf, _, button)
    if not E.db.AYIJE or not E.db.AYIJE.border.AuraUF then return end
    if uf.isNameplate then return end

    if not button.IsBorder then
        BORDER:CreateBorder(button)
        BORDER:BindBorderColorWithBorder(button.border, button)
        button.IsBorder = true
    end

    if not button.lastColorUpdate or GetTime() - button.lastColorUpdate > 0.1 then
        local r, g, b, a = button.border:GetBackdropBorderColor()
        button.Count:SetTextColor(r, g, b, a)
        button.lastColorUpdate = GetTime()
    end
end

function S:ElvUI_UnitFrames_Configure_AuraBars(_, f)
    if not f.db or not f.db.aurabar or not f.db.aurabar.enable then return end
    for _, statusBar in ipairs(f.AuraBars) do
        S:ElvUI_UnitFrames_Construct_AuraBars(nil, statusBar)
    end
end

function S:ElvUI_UnitFrames_Construct_AuraBars(_, f)
    if not f then return end
    f.icon:SetPoint("RIGHT", f, "LEFT", -9, 0)
    for _, child in next, { f:GetChildren() } do
        if not child.IsBorder then
            BORDER:CreateBorder(child)
            child.IsBorder = true
        end
    end
end

function S:ProfileUpdate()
    local config = E.db.AYIJE and E.db.AYIJE.border
    if not config then return end

    local units = { "player", "target", "targettarget", "focus", "focustarget", "pet", "pettarget", "targettargettarget" }
    for _, unit in ipairs(units) do
        local f = UF[unit]
        if f and UF.db.units[unit] and UF.db.units[unit].enable then
            BorderAndSeparator(f)
        end
    end

    for i = 1, 5 do
        local boss = _G["ElvUF_Boss"..i]
        if boss and config.Boss and E.db.unitframe.units.boss.enable then
            BorderAndSeparator(boss)
        end
        local arena = _G["ElvUF_Arena"..i]
        if arena and config.Arena and E.db.unitframe.units.arena.enable then
            BorderAndSeparator(arena)
        end
    end

    for i = 1, 2 do
        local tank = _G["ElvUF_TankUnitButton"..i]
        if tank and config.Maintankofftank then
            BorderAndSeparator(tank)
        end
        local assist = _G["ElvUF_AssistUnitButton"..i]
        if assist and config.AssistUnits then
            BorderAndSeparator(assist)
        end
    end
end

function S:UnitFrames()
    S:SecureHook(UF, "CreateAndUpdateUF", "ElvUI_UnitFrames")
    S:SecureHook(UF, "CreateAndUpdateUFGroup", "ElvUI_UnitFramesGroup")
    S:SecureHook(UF, "CreateAndUpdateHeaderGroup", "ElvUI_UnitFramesGroupRaidParty")
    S:SecureHook(UF, "PostUpdateAura", "ElvUI_UnitFrames_PostUpdateAura")
    S:SecureHook(UF, "Configure_AuraBars", "ElvUI_UnitFrames_Configure_AuraBars")
    S:SecureHook(UF, "Construct_AuraBars", "ElvUI_UnitFrames_Construct_AuraBars")

    -- ✅ Ensure it runs after profile swap
    hooksecurefunc(E, "StaggeredUpdateAll", function() S:ProfileUpdate() end)
end

S:AddCallback("UnitFrames")
