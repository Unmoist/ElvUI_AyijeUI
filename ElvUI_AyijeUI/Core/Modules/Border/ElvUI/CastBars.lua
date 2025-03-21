local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local UF = E:GetModule("UnitFrames")

local _G = _G

local CreateFrame = CreateFrame


function S:ElvUI_UnitFrames_SkinCastBar(_, frame)
	if not frame.Castbar then
		return
	end

	local db = frame.db.castbar

	frame.Castbar:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcast.tga")
	frame.Castbar.bg:SetTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastback.tga")
	BORDER:CreateBorder(frame.Castbar.backdrop, 1)

	BORDER:CreateBorder(frame.Castbar.ButtonIcon.bg)

	--Work in progress. 
	--[[
		local castbarheight = frame.Castbar:GetHeight() + 50

	if frame.Castbar.Spark_ then
		frame.Castbar.Spark_:SetTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\CastbarGlow.tga") 
		frame.Castbar.Spark_:SetSize(castbarheight, castbarheight)

		frame.Castbar.Spark_:ClearAllPoints()

		-- Recalculate the position based on the spark width and height
		if db.reverse then
				-- When reversed, anchor it to the right side of the bar
				frame.Castbar.Spark_:SetPoint("CENTER", frame.Castbar:GetStatusBarTexture(), "LEFT")
		else
				-- When not reversed, anchor it to the left side of the bar
				frame.Castbar.Spark_:SetPoint("CENTER", frame.Castbar:GetStatusBarTexture(), "RIGHT")
		end
		
		frame.Castbar.Spark_:SetBlendMode("BLEND")
		frame.Castbar.Spark_:SetTexCoord(0, 1, 0, 1)
		frame.Castbar.Spark_:SetVertexColor(1, 1, 1, 1)
	end
]]

	frame.Castbar:HookScript("OnValueChanged", function(self)
		if self.channeling then
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastchannel.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)  -- Set the color to white (R, G, B)
		elseif not self.notInterruptible and self.unit and self.unit ~= "player" then
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcast.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)  -- Set the color to white (R, G, B)
		elseif self.notInterruptible then
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastnonbreakable.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)  -- Set the color to white (R, G, B)
		else
			-- Default texture for player casts or fallback
			self:SetStatusBarTexture("Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcast.tga")
			self:SetStatusBarColor(1, 1, 1, 1)
			self.bg:SetVertexColor(1, 1, 1)  -- Set the color to white (R, G, B)

		end
	end)
end

function S:ElvUI_CastBars()
	if not E.private.unitframe.enable then
		return
	end


	S:SecureHook(UF, "Configure_Castbar", "ElvUI_UnitFrames_SkinCastBar")
end

S:AddCallback("ElvUI_CastBars")
