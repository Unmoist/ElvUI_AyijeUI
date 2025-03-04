local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local UGL = E:NewModule("UnitFramesGlowline", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

local EP = LibStub("LibElvUIPlugin-1.0")
local UF = E:GetModule("UnitFrames")

local function UpdateGlowLine(healthBar, unit, healthBarHeight)
    local healthPercentage = UnitHealth(unit) / UnitHealthMax(unit) * 100
    if healthPercentage == 100 or healthPercentage == 0 then
        if healthBar.glowLine then
            healthBar.glowLine:Hide()
        end
    else
        if not healthBar.GLOWLINE then
            healthBar.glowLine = healthBar:CreateTexture(nil, "OVERLAY")
            healthBar.glowLine:SetTexture(Engine.Glowline)
            healthBar.glowLine:SetSize(5, healthBarHeight)
            healthBar.glowLine:SetPoint("CENTER", healthBar, "LEFT")
            healthBar.glowLine:SetBlendMode("ADD")
            healthBar.GLOWLINE = true
        end
        healthBar.glowLine:Show()
    end
end

local function RegisterHealthEvents(healthBar, unit, updateFunc)
    if not healthBar or not unit then return end

    healthBar:RegisterEvent("UNIT_HEALTH")
    healthBar:RegisterEvent("UNIT_MAXHEALTH")
    healthBar:SetScript("OnEvent", function(self, event, arg1)
        if arg1 == unit then
            updateFunc(self, unit, self:GetHeight())
        end
    end)
end

function UGL:ElvUI_UnitFrames(_, unit)
    local frame = UF[unit]
    if frame then
        local healthBar = _G[frame:GetName() .. "_HealthBar_OtherBar"]
        if healthBar then
            RegisterHealthEvents(healthBar, unit, UpdateGlowLine)
            UpdateGlowLine(healthBar, unit, healthBar:GetHeight())
        end
    end
end

function UGL:ElvUI_UnitFramesGroup(_, group, numGroup)
    for i = 1, numGroup do
        local unit = group..i
        local frame = UF[unit]
        if frame then
            local healthBar = _G[frame:GetName() .. "_HealthBar"]
            if healthBar then
                RegisterHealthEvents(healthBar, unit, UpdateGlowLine)
                UpdateGlowLine(healthBar, unit, healthBar:GetHeight())
            end
        end
    end
end

function UGL:ElvUI_UnitFramesGroupRaidParty(_, group, groupFilter, template, headerTemplate, skip)
    local partyUnits = {"ElvUF_PartyGroup1UnitButton"}
    local raidUnits = {"ElvUF_Raid1Group", "ElvUF_Raid2Group", "ElvUF_Raid3Group"}

    for _, baseName in ipairs(partyUnits) do
        for i = 1, 5 do
            local healthBar = _G[baseName..i.."_HealthBar"]
            local unit = _G[baseName..i] and _G[baseName..i].unit
            if healthBar and unit then
                RegisterHealthEvents(healthBar, unit, UpdateGlowLine)
                UpdateGlowLine(healthBar, unit, healthBar:GetHeight())
            end
        end
    end

    for _, baseName in ipairs(raidUnits) do
        for k = 1, 8 do
            for l = 1, 5 do
                local healthBar = _G[baseName..k.."UnitButton"..l.."_HealthBar"]
                local unit = _G[baseName..k.."UnitButton"..l] and _G[baseName..k.."UnitButton"..l].unit
                if healthBar and unit then
                    RegisterHealthEvents(healthBar, unit, UpdateGlowLine)
                    UpdateGlowLine(healthBar, unit, healthBar:GetHeight())
                end
            end
        end
    end
end

function UGL:Initialize()
    if not E.db.AYIJE.unitframe.unitFramesGlowline then return end

    self:SecureHook(UF, "CreateAndUpdateHeaderGroup", "ElvUI_UnitFramesGroupRaidParty")
    self:SecureHook(UF, "CreateAndUpdateUF", "ElvUI_UnitFrames")
    self:SecureHook(UF, "CreateAndUpdateUFGroup", "ElvUI_UnitFramesGroup")
end

E:RegisterModule(UGL:GetName())
