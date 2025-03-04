local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function ElvUI_SkinStatusReport()
	BORDER:CreateBorder(_G.ElvUIStatusReport, nil, nil, nil, nil, nil, true, false)
	BORDER:CreateBorder(_G.ElvUIStatusPlugins, nil, nil, nil, nil, nil, true, false)
end

function S:ElvUI_StatusReport()
	if not E.db.AYIJE.skins.statusReport then return end

	if E.StatusFrame then
		BORDER:ElvUI_SkinStatusReport()
	end

	BORDER:SecureHook(E, "CreateStatusFrame", ElvUI_SkinStatusReport)
end

S:AddCallback("ElvUI_StatusReport")
