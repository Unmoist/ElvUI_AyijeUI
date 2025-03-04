local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G
local InCombatLockdown = InCombatLockdown

local function ElvUI_SkinOptions()
	if not InCombatLockdown() then
		BORDER:CreateBorder(E:Config_GetWindow())
	end
end

local function ElvUI_SkinInstall()
	if not InCombatLockdown() then
		BORDER:CreateBorder(_G.ElvUIInstallFrame)
	end
end

local function ElvUI_SkinMoverPopup()
	if not _G.ElvUIMoverPopupWindow then
		return
	end

	BORDER:CreateBorder(_G.ElvUIMoverPopupWindow)
	BORDER:CreateBorder(_G.ElvUIMoverPopupWindow.header)
end

function S:ElvUI_Options()
	if not E.db.AYIJE.skins.options then return end

	S:SecureHook(E, "ToggleOptions", ElvUI_SkinOptions)

	if _G.ElvUIInstallFrame then
		BORDER:CreateBorder(_G.ElvUIInstallFrame)
	else
		S:SecureHook(E, "Install", ElvUI_SkinInstall)
	end

	S:SecureHook(E, "ToggleMoveMode", ElvUI_SkinMoverPopup)
	BORDER:CreateBorder(_G.ElvUIBindPopupWindowHeader)
end

S:AddCallback("ElvUI_Options")
