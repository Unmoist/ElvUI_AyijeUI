local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local TOT = E:GetModule("TotemTracker")

local _G = _G

local MAX_TOTEMS = MAX_TOTEMS

local function ElvUI_TotemTracker_Initialize()
	for i = 1, MAX_TOTEMS do
		local ElvUI_TotemTrackerTotem = _G["ElvUI_TotemTrackerTotem" .. i]
		if ElvUI_TotemTrackerTotem and not ElvUI_TotemTrackerTotem.IsBorder then
			BORDER:CreateBorder(ElvUI_TotemTrackerTotem, nil, nil, nil, nil, nil, false, true)
			ElvUI_TotemTrackerTotem.IsBorder = true
		end
	end
end

function S:ElvUI_TotemTracker()
	if not E.db.AYIJE.skins.totemTracker then return end

	if TOT.Initialized then
		ElvUI_TotemTracker_Initialize()
	else
		S:SecureHook(TOT, "Initialize", ElvUI_TotemTracker_Initialize)
	end
end

S:AddCallback("ElvUI_TotemTracker")
