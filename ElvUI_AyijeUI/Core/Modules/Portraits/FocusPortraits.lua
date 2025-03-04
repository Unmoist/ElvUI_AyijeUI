local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule('UnitFrames')
local ElvUF = E.oUF

local FP = E:NewModule('Focus Portrait', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

-- Main Function
function FP:Initialize()
    if not (E.db.AYIJE.border.focuspor and E.db.unitframe.units.focus.enable and E.private.unitframe.enable) then return end
    local FocusPortrait
    local FocusframeEvent = CreateFrame("Frame")
    FocusframeEvent:RegisterEvent("PLAYER_FOCUS_CHANGED")
    FocusframeEvent:RegisterEvent("PORTRAITS_UPDATED")
    FocusframeEvent:SetScript("OnEvent", function(self, event)
        if FocusPortrait then
            FocusPortrait:Hide()
            FocusPortrait = nil
        end
        if UnitExists("focus") then
            local focusHeight = ElvUF_Focus:GetHeight()
            FocusPortrait = CreateFrame("Frame", nil, ElvUF_Focus, "BackdropTemplate")
            FocusPortrait:SetSize(focusHeight + 20, focusHeight + 20)
            FocusPortrait:SetPoint("CENTER", ElvUF_Focus, "RIGHT", E.db.AYIJE.unitframe.focuspositionPortraits, 0)
            FocusPortrait:SetFrameLevel(ElvUF_Focus:GetFrameLevel() + E.db.AYIJE.unitframe.framelevelPortraits)

            local FocusPortraitTexture = FocusPortrait:CreateTexture(nil, "OVERLAY")
            FocusPortraitTexture:SetAllPoints(FocusPortrait)
            FocusPortraitTexture:SetTexture(Engine.Portrait)
            SetPortraitTexture(FocusPortraitTexture, 'focus')

            local FocusPortraitBorder = CreateFrame("Frame", nil, FocusPortrait, "BackdropTemplate")
            FocusPortraitBorder:SetSize(FocusPortrait:GetHeight() + 60, FocusPortrait:GetWidth() + 60)
            FocusPortraitBorder:SetPoint("CENTER", FocusPortrait, "CENTER")

            local FocusPortraitBorderTexture = FocusPortraitBorder:CreateTexture(nil, "OVERLAY")
            FocusPortraitBorderTexture:SetAllPoints(FocusPortraitBorder)
            FocusPortraitBorderTexture:SetTexture(Engine.PortraitBorder)
            FocusPortraitBorderTexture:SetVertexColor(1, 1, 1, 1)
            FocusPortraitBorderTexture:SetDesaturated(true)

            local _, unitClass = UnitClass("focus")
            local isPlayer = UnitIsPlayer("focus")
            local color

            if isPlayer then
                color = ElvUF.colors.class[unitClass]
            else
                color = ElvUF.colors.reaction[UnitReaction("focus", 'player')]
            end

            FocusPortraitBorderTexture:SetVertexColor((color and color.r) or 0.8, (color and color.g) or 0.8, (color and color.b) or 0.8, 1)
        end
    end)
end

E:RegisterModule(FP:GetName());
