local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local DT = E:GetModule("DataTexts")
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function hookPanelSetTemplate(panel, template)
	if not panel.border then
		return
	end

	if template == "NoBackdrop" then
		panel.border:Hide()
	else
		panel.border:Show()
	end
end

local function createPanelBorder(panel)
	if panel.border then
		return
	end

	BORDER:CreateBorder(panel)

	hooksecurefunc(panel, "SetTemplate", hookPanelSetTemplate)
	hookPanelSetTemplate(panel, panel.template)
end

function S:ElvUI_SkinDataPanel(_, name)
	local panel = DT:FetchFrame(name)

	createPanelBorder(panel)
end

function S:ElvUI_DataPanels()
	if not E.db.AYIJE.skins.dataPanels then return end

	if DT.PanelPool.InUse then
		for name, frame in pairs(DT.PanelPool.InUse) do
			createPanelBorder(frame)
		end
	end

	if DT.PanelPool.Free then
		for name, frame in pairs(DT.PanelPool.Free) do
			createPanelBorder(frame)
		end
	end
	
	if _G.ElvUI_DTPanel0.border then
		_G.ElvUI_DTPanel0.border:Hide()
	end

	S:SecureHook(DT, "BuildPanelFrame", "ElvUI_SkinDataPanel")
end

S:AddCallback("ElvUI_DataPanels")
