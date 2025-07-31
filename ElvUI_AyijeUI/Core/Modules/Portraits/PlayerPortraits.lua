local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule('UnitFrames')
local ElvUF = E.oUF

local PP = E:NewModule('Player Portrait', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

local PlayerPortraitFrame

-- Utility: Build the portrait
local function CreatePlayerPortrait()
    if PlayerPortraitFrame then
        PlayerPortraitFrame:Hide()
        PlayerPortraitFrame = nil
    end

    if not (E.db.AYIJE and E.db.AYIJE.border.playerpor and E.db.unitframe.units.player.enable and E.private.unitframe.enable) then
        return
    end

    if not UnitExists("player") or not ElvUF_Player then return end

    local playerHeight = ElvUF_Player:GetHeight()
    local Portrait = CreateFrame("Frame", nil, ElvUF_Player, "BackdropTemplate")
    Portrait:SetSize(playerHeight + 20, playerHeight + 20)
    Portrait:SetPoint("CENTER", ElvUF_Player, "LEFT", E.db.AYIJE.unitframe.playerpositionPortraits or 0, 0)
    Portrait:SetFrameLevel(ElvUF_Player:GetFrameLevel() + (E.db.AYIJE.unitframe.framelevelPortraits or 0))

    local PortraitTexture = Portrait:CreateTexture(nil, "OVERLAY")
    PortraitTexture:SetAllPoints(Portrait)
    PortraitTexture:SetTexture(Engine.Portrait)
    SetPortraitTexture(PortraitTexture, "player")

    local Border = CreateFrame("Frame", nil, Portrait, "BackdropTemplate")
    Border:SetSize(Portrait:GetWidth() * 2.2, Portrait:GetHeight() * 2.2)
    Border:SetPoint("CENTER", Portrait, "CENTER")

    local BorderTexture = Border:CreateTexture(nil, "OVERLAY")
    BorderTexture:SetAllPoints(Border)
    BorderTexture:SetTexture(Engine.PortraitBorder)
    BorderTexture:SetVertexColor(1, 1, 1, 1)
    BorderTexture:SetDesaturated(true)

    local _, unitClass = UnitClass("player")
    local color

    if UnitIsPlayer("player") then
        color = ElvUF.colors.class[unitClass]
    else
        local reaction = UnitReaction("player", "player")
        color = reaction and ElvUF.colors.reaction[reaction]
    end

    BorderTexture:SetVertexColor(
        (color and color.r) or 0.8,
        (color and color.g) or 0.8,
        (color and color.b) or 0.8,
        1
    )

    PlayerPortraitFrame = Portrait
end

-- Main init
function PP:Initialize()
    self.FrameEvent = CreateFrame("Frame")
    self.FrameEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.FrameEvent:RegisterEvent("PORTRAITS_UPDATED")
    self.FrameEvent:SetScript("OnEvent", function()
        CreatePlayerPortrait()
    end)

    -- Also reapply on profile swap:
    hooksecurefunc(E, "StaggeredUpdateAll", function() CreatePlayerPortrait() end)
end

E:RegisterModule(PP:GetName())
