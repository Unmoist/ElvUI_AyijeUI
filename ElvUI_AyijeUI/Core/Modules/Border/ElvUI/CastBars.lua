local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')
local S = E:GetModule('Skins')
local UF = E:GetModule("UnitFrames")

-- Texture paths
local blizzcastback = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastback.tga"
local blizzcast = [[UI-CastingBar-Filling-Standard]] 
local blizzcastchannel = [[UI-CastingBar-Filling-Channel]] 
local blizzcastnonbreakable = [[UI-CastingBar-Uninterruptable]]

---------------------------------------------------
-- Texture Logic Helper
---------------------------------------------------
local function UpdateCastBarTexture(self, unit)
    if not self then return end

    -- Protection against "Secret Value" API
    local notInterruptible = E:NotSecretValue(self.notInterruptible) and self.notInterruptible
    local channeling = E:NotSecretValue(self.channeling) and self.channeling

    -- 1. Apply Texture based on state (Visual Only)
    -- PRIORITY: Non-interruptible should always take precedence over channeling
    if notInterruptible and (UnitIsPlayer(unit) or (unit ~= 'player' and UnitCanAttack('player', unit))) then
        self:SetStatusBarTexture(blizzcastnonbreakable)
    elseif channeling then
        self:SetStatusBarTexture(blizzcastchannel)
    else
        self:SetStatusBarTexture(blizzcast)
    end
    
    -- 2. Force Color and Background (Visual Only)
    self:SetStatusBarColor(1, 1, 1, 1)
    
    if self.bg and self.bg.SetTexture then
        self.bg:SetTexture(blizzcastback)
        self.bg:SetVertexColor(1, 1, 1, 1)
    end
end

---------------------------------------------------
-- Skinning Function
---------------------------------------------------
function S:ElvUI_UnitFrames_SkinCastBar(_, frame)
    local castbar = frame.Castbar
    if not castbar or frame.CastbarSkinned then return end

    -- Apply Borders (Only once)
    if castbar.backdrop then 
        BORDER:CreateBorder(castbar.backdrop) 
    end
    if castbar.ButtonIcon and castbar.ButtonIcon.bg then 
        BORDER:CreateBorder(castbar.ButtonIcon.bg) 
    end

    -- Hook state changes safely.
    if castbar.PostCastStart then
        hooksecurefunc(castbar, "PostCastStart", UpdateCastBarTexture)
    end

    if castbar.PostCastInterruptible then
        hooksecurefunc(castbar, "PostCastInterruptible", UpdateCastBarTexture)
    end

    frame.CastbarSkinned = true
end

---------------------------------------------------
-- Hook Into ElvUI
---------------------------------------------------
function S:ElvUI_CastBars()
    if not E.private.unitframe.enable then return end
    S:SecureHook(UF, "Configure_Castbar", "ElvUI_UnitFrames_SkinCastBar")
end

S:AddCallback("ElvUI_CastBars")