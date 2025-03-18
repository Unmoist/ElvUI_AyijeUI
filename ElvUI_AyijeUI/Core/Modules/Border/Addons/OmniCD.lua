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
	hooksecurefunc(_G.OmniCD[1].Party, "AcquireIcon", function(_, barFrame, iconIndex, unitBar)
		local icon = barFrame.icons[iconIndex]

		for i = 1, 8 do
			if barFrame:GetName() == ("OmniCDraidBar" .. i) then
				if icon and not icon.Border then
					BORDER:CreateBorder(icon, nil, -7.5, 7.5, 7.5, -7.5)
					icon.Border = true
				end
				break  -- Exit the loop early once a match is found
			end
		end
	
		if barFrame:GetName() == "OmniCDBar1" then
			if icon and not icon.Border then
				BORDER:CreateBorder(icon)
				icon.Border = true
			end
		end
	end)
end


function S:OmniCD()
	if not E.db.AYIJE.skins.omnicd then return end
	S:OmniCD_ConfigGUI()
	S:OmniCD_Party_Icon()
end

S:AddCallbackForAddon("OmniCD")
