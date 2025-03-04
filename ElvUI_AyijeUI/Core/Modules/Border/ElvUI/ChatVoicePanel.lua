local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local EC = E:GetModule("Chat")

local _G = _G

function S:ElvUI_ChatVoicePanel()
	if not E.db.AYIJE.skins.chatVoicePanel then return end

	if _G.ElvUIChatVoicePanel then
		BORDER:CreateBorder(_G.ElvUIChatVoicePanel)
	end
end

S:AddCallback("ElvUI_ChatVoicePanel")
