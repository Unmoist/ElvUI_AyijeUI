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

function S:OmniCD_Party_Icon()
	local OmniCD = _G.OmniCD and _G.OmniCD[1]
	if not OmniCD then return end

	hooksecurefunc(OmniCD.Party.BarFrameIconMixin, "SetBorder", function(icon)
		if not icon or not icon.GetObjectType then return end

		if icon:GetObjectType() == "Texture" then
				icon = icon:GetParent()
		end

		if icon.border then
				icon.border:Kill()
		end

		local border = CreateFrame("Frame", nil, icon, BackdropTemplateMixin and "BackdropTemplate")
		if not border then return end

		local width = icon:GetWidth() + 16
		local height = icon:GetHeight() + 16
		local x, y = icon:GetCenter()

		border:SetFrameStrata(icon:GetFrameStrata())
		border:SetFrameLevel(icon:GetFrameLevel() + 3)
		border:SetBackdrop(Engine.Border)
		border:SetSize(width, height)

		if x and y then
				border:ClearAllPoints()
				border:SetPoint("CENTER", UIParent, "BOTTOMLEFT", math.floor(x), math.floor(y + 0.7))
		end

		icon.border = border
	end)

	hooksecurefunc(OmniCD.Party.BarFrameIconMixin, "SetExIconName", function(icon)
			if icon and not icon.Border then
					BORDER:CreateBorder(icon)
					icon.Border = true
			end
	end)
end

function S:OmniCD()
	if not E.db.AYIJE.skins.omnicd then return end

	S:OmniCD_ConfigGUI()
	S:OmniCD_Party_Icon()
end

S:AddCallbackForAddon("OmniCD")
