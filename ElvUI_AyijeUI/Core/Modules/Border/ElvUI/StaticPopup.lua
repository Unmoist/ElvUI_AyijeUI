local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G

function S:ElvUI_StaticPopup()
	if not E.db.AYIJE.skins.staticPopup then return end
	E:Delay(0.1, function()
		for i = 1, 3 do
			local frameName = "ElvUI_StaticPopup" .. i
			local frame = _G[frameName]
			if frame then
				BORDER:CreateBorder(frame)
				for j = 1, 3 do
					local button = _G[frameName .. "Button" .. j]
					BORDER:CreateBorder(button, nil, nil, nil, nil, nil, false, true)
				end
			end
		end
	end)
end

S:AddCallback("ElvUI_StaticPopup")
