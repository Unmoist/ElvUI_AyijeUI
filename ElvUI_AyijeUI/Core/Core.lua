local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local CH = E:GetModule('Chat')
local DT = E:GetModule('DataTexts')
local AceAddon = E.Libs.AceAddon
local C_UI_Reload = C_UI.Reload
local format, print = format, print
local hooksecurefunc = hooksecurefunc
local SetCVar = SetCVar
local S = E:GetModule('Skins')
local GameMenuFrame = _G.GameMenuFrame
local DisableAddOn = C_AddOns.DisableAddOn
local EnableAddOn = C_AddOns.EnableAddOn
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local GetNumAddOns = C_AddOns.GetNumAddOns
local LoadAddOn = C_AddOns.LoadAddOn

-- Global strings
local ACCEPT = ACCEPT
local CANCEL = CANCEL

-- Chat print
function Engine:Print(msg)
	print(Engine.Name .. ': ' .. msg)
end

-- Reload popup
E.PopupDialogs.AYIJE_RL = {
	text = L["AyijeUI\nReload required - want continue?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = C_UI_Reload,
	whileDead = 1,
	hideOnEscape = false,
}

-- Slightly modified for title text and additional chat print
E.PopupDialogs.AYIJE_EDITBOX = {
	text = Engine.Name,
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine('text')
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:HighlightText()
		self.editBox:SetJustifyH('CENTER')
		Engine:Print(data)
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText() ~= self.temptxt then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
	OnAccept = E.noop,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}