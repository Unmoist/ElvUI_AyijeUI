local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local AFK = E:GetModule("AFK")

local _G = _G

function S:ElvUI_AFK()
	if not E.db.AYIJE.skins.afk then return end

	BORDER:CreateBorder(AFK.AFKMode.bottom, 10)

	AFK.AFKMode.bottom.guild:ClearAllPoints()
	AFK.AFKMode.bottom.guild:Point("TOPLEFT", AFK.AFKMode.bottom.name, "BOTTOMLEFT", 0, -11)

	AFK.AFKMode.bottom.time:ClearAllPoints()
	AFK.AFKMode.bottom.time:Point("TOPLEFT", AFK.AFKMode.bottom.guild, "BOTTOMLEFT", 0, -11)
end

S:AddCallback("ElvUI_AFK")
