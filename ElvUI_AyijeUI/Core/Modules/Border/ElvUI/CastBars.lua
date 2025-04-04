local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local UF = E:GetModule("UnitFrames")

local blizzcastback = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastback.tga"
local blizzcast = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcast.tga"
local blizzcastchannel = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastchannel.tga"
local blizzcastnonbreakable = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastnonbreakable.tga"

function S:ElvUI_UnitFrames_SkinCastBar(_, frame)
	if not frame.Castbar then	return end

	if not frame.TEXTURESET then
		frame.Castbar:SetStatusBarTexture(blizzcast)
		frame.Castbar.bg:SetTexture(blizzcastback)
		frame.TEXTURESET = true
	end
	
	if frame.CastbarSkinned then return end

	BORDER:CreateBorder(frame.Castbar.backdrop)
	BORDER:CreateBorder(frame.Castbar.ButtonIcon.bg)

	frame.Castbar:HookScript("OnValueChanged", function(self)
		if self.channeling then
			self:SetStatusBarTexture(blizzcastchannel)
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)
		elseif not self.notInterruptible and self.unit and self.unit ~= "player" then
			self:SetStatusBarTexture(blizzcast)
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)
		elseif self.notInterruptible then
			self:SetStatusBarTexture(blizzcastnonbreakable)
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)
		else
			self:SetStatusBarTexture(blizzcast)
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1) 
		end
	end)
	frame.CastbarSkinned = true
end

function S:ElvUI_CastBars()
	if not E.private.unitframe.enable then return end

	S:SecureHook(UF, "Configure_Castbar", "ElvUI_UnitFrames_SkinCastBar")
end

S:AddCallback("ElvUI_CastBars")
