local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local UF = E:GetModule("UnitFrames")

function S:ElvUI_ToggleTransparentStatusBar()
	E.db.unitframe.colors.transparentCastbar = false
end

function S:ElvUI_UnitFrames_SkinCastBar(_, frame)
	if not frame.Castbar then	return end

	frame.Castbar:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcast.tga")
	frame.Castbar.bg:SetTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastback.tga")
	
	BORDER:CreateBorder(frame.Castbar.backdrop)
	BORDER:CreateBorder(frame.Castbar.ButtonIcon.bg)

	frame.Castbar:HookScript("OnValueChanged", function(self)
		if self.channeling then
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastchannel.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)
		elseif not self.notInterruptible and self.unit and self.unit ~= "player" then
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcast.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)
		elseif self.notInterruptible then
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastnonbreakable.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)
		else
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcast.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1) 
		end
	end)
end

function S:ElvUI_CastBars()
	if not E.private.unitframe.enable then return end

	S:SecureHook(UF, "Configure_Castbar", "ElvUI_UnitFrames_SkinCastBar")
	S:SecureHook(UF, "ToggleTransparentStatusBar", "ElvUI_ToggleTransparentStatusBar")
end

S:AddCallback("ElvUI_CastBars")
