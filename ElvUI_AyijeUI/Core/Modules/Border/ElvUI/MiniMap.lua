local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local M = E:GetModule("Minimap")


local _G = _G

function S:ElvUI_MiniMap()
	if not E.db.AYIJE.skins.Minimap then return end

	local Minimap = _G.Minimap
	BORDER:CreateBorder(Minimap.backdrop)
	BORDER:CreateBorder(_G.MinimapRightClickMenu)
end

S:AddCallback("ElvUI_MiniMap")
