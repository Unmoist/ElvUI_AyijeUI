local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs

local function RaidUtility_ShowButton_OnClick()
	if InCombatLockdown() then
		return
	end

	_G.RaidUtility_CloseButton:ClearAllPoints()
	local anchor = _G.RaidUtilityPanel:GetPoint()
	if anchor == "TOP" then
		_G.RaidUtility_CloseButton:Point("TOP", _G.RaidUtilityPanel, "BOTTOM", 0, -4)
	else
		_G.RaidUtility_CloseButton:Point("BOTTOM", _G.RaidUtilityPanel, "TOP", 0, 4)
	end
end

function S:RaidUtility()
	if not E.db.AYIJE.skins.raidUtility then return end

	local frames = {
		_G.RaidUtilityPanel,
		_G.RaidUtility_ShowButton,
		_G.RaidUtility_CloseButton,
		_G.RaidUtilityRoleIcons
	}

	for _, frame in pairs(frames) do
		BORDER:CreateBorder(frame, nil, nil, nil, nil, nil, false, true)
	end

	if _G.RaidUtility_ShowButton then
		BORDER:SecureHookScript(_G.RaidUtility_ShowButton, "OnClick", RaidUtility_ShowButton_OnClick)
	end
end

S:AddCallback("RaidUtility")
