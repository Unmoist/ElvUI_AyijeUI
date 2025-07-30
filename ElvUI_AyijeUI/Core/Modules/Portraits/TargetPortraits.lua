local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule('UnitFrames')
local ElvUF = E.oUF

local TP = E:NewModule('Target Portrait', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

-- Main Function
function TP:Initialize()
    if not (E.db.AYIJE.border.targetpor and E.db.unitframe.units.target.enable and E.private.unitframe.enable) then return end
    local TargetPortrait

    local TargetframeEvent = CreateFrame("Frame")
    TargetframeEvent:RegisterEvent("PLAYER_TARGET_CHANGED")
    TargetframeEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
    TargetframeEvent:RegisterEvent("PORTRAITS_UPDATED")
    TargetframeEvent:SetScript("OnEvent", function(self, event)
        if TargetPortrait then
            TargetPortrait:Hide()
            TargetPortrait = nil
        end
        if UnitExists("target") then
            local targetHeight = ElvUF_Target:GetHeight()
            TargetPortrait = CreateFrame("Frame", nil, ElvUF_Target, "BackdropTemplate")
            TargetPortrait:SetSize(targetHeight + 20, targetHeight + 20)
            TargetPortrait:SetPoint("CENTER", ElvUF_Target, "RIGHT", E.db.AYIJE.unitframe.targetpositionPortraits, 0)
            TargetPortrait:SetFrameLevel(ElvUF_Target:GetFrameLevel() + E.db.AYIJE.unitframe.framelevelPortraits)

            local TargetPortraitTexture = TargetPortrait:CreateTexture(nil, "OVERLAY")
            TargetPortraitTexture:SetAllPoints(TargetPortrait)
            TargetPortraitTexture:SetTexture(Engine.Portrait)
            SetPortraitTexture(TargetPortraitTexture, 'target')

            local TargetPortraitBorder = CreateFrame("Frame", nil, TargetPortrait, "BackdropTemplate")
            TargetPortraitBorder:SetSize(TargetPortrait:GetWidth() * 2.2, TargetPortrait:GetHeight() * 2.2)
            TargetPortraitBorder:SetPoint("CENTER", TargetPortrait, "CENTER")

            local TargetPortraitBorderTexture = TargetPortraitBorder:CreateTexture(nil, "OVERLAY")
            TargetPortraitBorderTexture:SetAllPoints(TargetPortraitBorder)
            TargetPortraitBorderTexture:SetTexture(Engine.PortraitBorder)
            TargetPortraitBorderTexture:SetVertexColor(1, 1, 1, 1)
            TargetPortraitBorderTexture:SetDesaturated(true)

            local _, unitClass = UnitClass("target")
            local isPlayer = UnitIsPlayer("target")
            local color

            if isPlayer then
                color = ElvUF.colors.class[unitClass]
            else
                color = ElvUF.colors.reaction[UnitReaction("target", 'player')]
            end

            TargetPortraitBorderTexture:SetVertexColor((color and color.r) or 0.8, (color and color.g) or 0.8, (color and color.b) or 0.8, 1)
        end
    end)
end

E:RegisterModule(TP:GetName());
