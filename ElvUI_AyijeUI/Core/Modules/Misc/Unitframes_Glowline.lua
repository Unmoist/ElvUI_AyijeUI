local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI);
local UGL = E:NewModule('UnitFramesGlowline', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local EP = LibStub("LibElvUIPlugin-1.0");
local UF = E:GetModule("UnitFrames");

local function UpdateGlowLineUnitFrames(healthBar, unit, healthBarHeight)
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

function UGL:ElvUI_UnitFrames(_, unit)
    local frame = UF[unit]
    if frame then
        local healthBar = _G[frame:GetName() .. "_HealthBar_OtherBar"]
        local healthBarheightuf = healthBar:GetHeight()

        if healthBar and unit then
            healthBar:RegisterEvent("UNIT_HEALTH")
            healthBar:RegisterEvent("UNIT_MAXHEALTH")
            healthBar:SetScript("OnEvent", function(self, event, arg1)
                if arg1 == unit then
                    UpdateGlowLineUnitFrames(healthBar, unit, healthBarheightuf)
                end
            end)

            UpdateGlowLineUnitFrames(healthBar, unit, healthBarheightuf)
        end
    end
end

local function UpdateGlowLineGroup(healthBar, unit, healthBarHeight)
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
            healthBar.glowLine:SetPoint("CENTER", healthBar.backdropTex, "LEFT")
            healthBar.glowLine:SetBlendMode("ADD")
            healthBar.GLOWLINE = true
        end
        healthBar.glowLine:Show()
    end
end

function UGL:ElvUI_UnitFramesGroup (_, group, numGroup)
    for i = 1, numGroup do
        local unit = group..i
        local frame = UF[unit]
        local healthBar = _G[frame:GetName() .. "_HealthBar"]

        if healthBar and unit then
            local healthBarheightgroup = healthBar:GetHeight()

            healthBar:RegisterEvent("UNIT_HEALTH")
            healthBar:RegisterEvent("UNIT_MAXHEALTH")
            healthBar:SetScript("OnEvent", function(self, event, arg1)
                if arg1 == unit then
                    UpdateGlowLineGroup(healthBar, unit, healthBarheightgroup)
                end
            end)

            UpdateGlowLineGroup(healthBar, unit, healthBarheightgroup)
        end
    end
end

local function UpdateGlowLine(button, unit, healthBarHeight)
    local healthPercentage = UnitHealth(unit) / UnitHealthMax(unit) * 100
    if healthPercentage == 100 or healthPercentage == 0 then
        if button.glowLine then
            button.glowLine:Hide()
        end
    else
        if not button.GLOWLINE then
            button.glowLine = button:CreateTexture(nil, "OVERLAY")
            button.glowLine:SetTexture(Engine.Glowline)
            button.glowLine:SetSize(5, healthBarHeight)
            button.glowLine:SetPoint("CENTER", button.backdropTex, "LEFT")
            button.glowLine:SetBlendMode("ADD")
            button.GLOWLINE = true
        end
        button.glowLine:Show()
    end
end

function UGL:ElvUI_UnitFramesGroupRaidParty(_, group, groupFilter, template, headerTemplate, skip)
    for i = 1, 5 do
        local pbutton = _G["ElvUF_PartyGroup1UnitButton"..i..'_HealthBar']
        local punit = _G["ElvUF_PartyGroup1UnitButton"..i] and _G["ElvUF_PartyGroup1UnitButton"..i].unit
    
        if pbutton and punit then
            local healthBarheightParty = pbutton:GetHeight()

            pbutton:RegisterEvent("UNIT_HEALTH")
            pbutton:RegisterEvent("UNIT_MAXHEALTH")
            pbutton:SetScript("OnEvent", function(self, event, arg1)
                if arg1 == punit then
                    UpdateGlowLine(pbutton, punit, healthBarheightParty)
                end
            end)

            UpdateGlowLine(pbutton, punit, healthBarheightParty)
        end
    end
    

    for w = 1, 3 do 
        for k = 1, 8 do
            for l = 1, 5 do
                local rbutton = _G["ElvUF_Raid"..w.."Group"..k..'UnitButton'..l..'_HealthBar']
                local runit = _G["ElvUF_Raid"..w.."Group"..k..'UnitButton'..l] and _G["ElvUF_Raid"..w.."Group"..k..'UnitButton'..l].unit
    
                if rbutton and runit then
                    local healthBarheightRaid = rbutton:GetHeight()
                    
                    rbutton:RegisterEvent("UNIT_HEALTH")
                    rbutton:RegisterEvent("UNIT_MAXHEALTH")
                    rbutton:SetScript("OnEvent", function(self, event, arg1)
                        if arg1 == runit then
                            UpdateGlowLine(rbutton, runit, healthBarheightRaid)
                        end
                    end)

                    UpdateGlowLine(rbutton, runit, healthBarheightRaid)
                end
            end
        end
    end      
end

function UGL:Initialize()
	if not E.db.AYIJE.unitframe.unitFramesGlowline then return end

    UGL:SecureHook(UF, "CreateAndUpdateHeaderGroup", "ElvUI_UnitFramesGroupRaidParty")
    UGL:SecureHook(UF, "CreateAndUpdateUF", "ElvUI_UnitFrames")
    UGL:SecureHook(UF, "CreateAndUpdateUFGroup", "ElvUI_UnitFramesGroup")
end

E:RegisterModule(UGL:GetName());
