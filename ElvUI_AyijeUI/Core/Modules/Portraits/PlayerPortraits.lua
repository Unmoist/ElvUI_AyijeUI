local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule('UnitFrames')
local ElvUF = E.oUF

local PP = E:NewModule('Player Portrait', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

-- Main Function
function PP:Initialize()
    if not (E.db.AYIJE.border.playerpor and E.db.unitframe.units.player.enable and E.private.unitframe.enable) then return end
    local PlayerPortrait

    local PlayerframeEvent = CreateFrame("Frame")
    PlayerframeEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
    PlayerframeEvent:RegisterEvent("PORTRAITS_UPDATED")
    PlayerframeEvent:SetScript("OnEvent", function(self, event)
        if PlayerPortrait then
            PlayerPortrait:Hide()
            PlayerPortrait = nil
        end
        if UnitExists("player") then
            local playerHeight = ElvUF_Player:GetHeight()
            PlayerPortrait = CreateFrame("Frame", nil, ElvUF_Player, "BackdropTemplate")
            PlayerPortrait:SetSize(playerHeight + 20, playerHeight + 20)
            PlayerPortrait:SetPoint("CENTER", ElvUF_Player, "LEFT", E.db.AYIJE.unitframe.playerpositionPortraits, 0)
            PlayerPortrait:SetFrameLevel(ElvUF_Player:GetFrameLevel() + E.db.AYIJE.unitframe.framelevelPortraits)

            local PlayerPortraitTexture = PlayerPortrait:CreateTexture(nil, "OVERLAY")
            PlayerPortraitTexture:SetAllPoints(PlayerPortrait)
            PlayerPortraitTexture:SetTexture(Engine.Portrait)
            SetPortraitTexture(PlayerPortraitTexture, 'player')

            local PlayerPortraitBorder = CreateFrame("Frame", nil, PlayerPortrait, "BackdropTemplate")
            PlayerPortraitBorder:SetSize(PlayerPortrait:GetHeight() + 60, PlayerPortrait:GetWidth() + 60)
            PlayerPortraitBorder:SetPoint("CENTER", PlayerPortrait, "CENTER")

            local PlayerPortraitBorderTexture = PlayerPortraitBorder:CreateTexture(nil, "OVERLAY")
            PlayerPortraitBorderTexture:SetAllPoints(PlayerPortraitBorder)
            PlayerPortraitBorderTexture:SetTexture(Engine.PortraitBorder)
            PlayerPortraitBorderTexture:SetVertexColor(1, 1, 1, 1)
            PlayerPortraitBorderTexture:SetDesaturated(true)

            local _, unitClass = UnitClass("player")
            local isPlayer = UnitIsPlayer("player")
            local color

            if isPlayer then
                color = ElvUF.colors.class[unitClass]
            else
                color = ElvUF.colors.reaction[UnitReaction("player", 'player')]
            end

            PlayerPortraitBorderTexture:SetVertexColor((color and color.r) or 0.8, (color and color.g) or 0.8, (color and color.b) or 0.8, 1)
        end
    end)
end

E:RegisterModule(PP:GetName());
