local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local CH = E:GetModule("Chat")

local _G = _G

function S:ElvUICopyChatFrame()
	if not E.db.AYIJE.skins.chatCopyFrame then return end

	local ElvUI_CopyChatFrame = _G.ElvUI_CopyChatFrame
	local CopyChatFrame = _G.CopyChatFrame

	if CopyChatFrame then 
		BORDER:CreateBorder(CopyChatFrame)
		BORDER:CreateBorder(_G.CopyChatScrollFrameScrollBarThumbTexture)
	else
		BORDER:CreateBorder(ElvUI_CopyChatFrame)
		BORDER:CreateBorder(_G.ElvUI_CopyChatScrollFrameScrollBarThumbTexture)
	end
end

S:AddCallback("ElvUICopyChatFrame")
