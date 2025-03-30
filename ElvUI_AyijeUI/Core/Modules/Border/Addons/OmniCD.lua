local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame

function S:OmniCD_ConfigGUI()
	local O = _G.OmniCD[1]

	hooksecurefunc(O.Libs.ACD, "Open", function(_, arg1)
		if arg1 == O.AddOn then
			local frame = O.Libs.ACD.OpenFrames.OmniCD.frame
			frame:SetTemplate("Transparent")
			BORDER:CreateBorder(frame)
		end
	end)
end

function S:OmniCD_Party_Icons()
	local OmniCD = _G.OmniCD and _G.OmniCD[1]
	if not OmniCD then return end

	hooksecurefunc(OmniCD.Party.BarFrameIconMixin, "SetExIconName", function(icon)
		if not icon or not icon.GetObjectType then return end
		if icon.BORDEREX then return end

		if icon:GetObjectType() == "Texture" then
				icon = icon:GetParent()
		end
	
		if icon.border then
				icon.border:Kill()
		end
	
		local border = CreateFrame("Frame", nil, icon, BackdropTemplateMixin and "BackdropTemplate")
		if not border then return end
	
		border:SetBackdrop(Engine.Border)
		border:SetFrameLevel(icon:GetFrameLevel() + 2)
		border:SetPoint("TOPLEFT" , icon, "TOPLEFT", -8.1, 8.1)
		border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 7.5, -7.5)
		
		icon.border = border
		icon.BORDEREX = true
	end)

	hooksecurefunc(OmniCD.Party.BarFrameIconMixin, "SetBorder", function(icon)
		if not icon or not icon.GetObjectType then return end
		if icon.BORDERSET then return end

		if icon:GetObjectType() == "Texture" then
				icon = icon:GetParent()
		end

		if icon.border then
				icon.border:Kill()
		end

		local border = CreateFrame("Frame", nil, icon, BackdropTemplateMixin and "BackdropTemplate")
		if not border then return end

		border:SetBackdrop(Engine.Border)
		border:SetFrameLevel(icon:GetFrameLevel() + 2)
		border:SetPoint("TOPLEFT" , icon, "TOPLEFT", -8, 8)
		border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 8, -8)
		
		icon.border = border
		icon.BORDERSET = true
	end)
end

function S:OmniCD()
	if not E.db.AYIJE.skins.omnicd then return end

	S:OmniCD_ConfigGUI()
	S:OmniCD_Party_Icons()
end

S:AddCallbackForAddon("OmniCD")
