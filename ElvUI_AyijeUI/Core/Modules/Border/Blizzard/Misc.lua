local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local _G = _G
local next = next
local unpack = unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

function S:BlizzardMiscFrames()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.misc) then return end

	BORDER:CreateBorder(_G.StaticPopup1ExtraButton, nil, nil, nil, nil, nil, false, true)

	BORDER:CreateBorder(_G.ElvUI_ReputationBarHolder)
	BORDER:CreateBorder(_G.ElvUI_ExperienceBarHolder)
	BORDER:CreateBorder(_G.ElvUI_ThreatBarHolder)
	BORDER:CreateBorder(_G.ElvUI_HonorBarHolder)
	BORDER:CreateBorder(_G.ElvUI_AzeriteBarHolder)
	
	-- Color Picker
	local ColorPickerFrame = _G.ColorPickerFrame
	BORDER:CreateBorder(ColorPickerFrame)
	BORDER:CreateBorder(ColorPickerFrame.Footer.OkayButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(ColorPickerFrame.Footer.CancelButton, nil, nil, nil, nil, nil, false, true)

	BORDER:HandleIcon(ColorPickerFrame.Content.ColorPicker.Value, true)
	
	BORDER:HandleIcon(ColorPickerFrame.Content.ColorPicker.Alpha, true)
	ColorPickerFrame.Content.ColorPicker.Alpha.backdrop.border:Hide()

	ColorPickerFrame:HookScript('OnShow', function(frame)
		if frame.hasOpacity then
			ColorPickerFrame.Content.ColorPicker.Alpha.backdrop.border:Show()
			ColorPickerFrame.Content.ColorPicker.Alpha.backdrop:Show()
		else
			ColorPickerFrame.Content.ColorPicker.Alpha.backdrop.border:Hide()
			ColorPickerFrame.Content.ColorPicker.Alpha.backdrop:Hide()
		end
	end)
   
	BORDER:HandleIcon(ColorPickerFrame.Content.ColorSwatchCurrent, true)
	BORDER:HandleIcon(ColorPickerFrame.Content.ColorSwatchOriginal, true)
	BORDER:HandleIcon(ColorPPCopyColorSwatch, true)

	ColorPickerFrame.Content.ColorSwatchCurrent:Point('TOPLEFT', ColorPickerFrame.Content, 'TOPRIGHT', -120, -32)
	ColorPickerFrame.Content.ColorSwatchOriginal:Point('TOPLEFT', ColorPickerFrame.Content.ColorSwatchCurrent, 'BOTTOMLEFT', 0, -5)

	BORDER:CreateBorder(ColorPPBoxR, nil, nil, nil, nil, nil, true)
	BORDER:CreateBorder(ColorPPBoxG, nil, nil, nil, nil, nil, true)
	BORDER:CreateBorder(ColorPPBoxB, nil, nil, nil, nil, nil, true)
	BORDER:CreateBorder(ColorPPBoxA, nil, nil, nil, nil, nil, true)
	
	BORDER:CreateBorder(ColorPPCopy, nil, -7, 7, 7, -7, false, true)
	ColorPPCopy:SetBackdrop('')
	BORDER:CreateBorder(ColorPPClass, nil, -7, 7, 7, -7, false, true)
	ColorPPClass:SetBackdrop('')
	BORDER:CreateBorder(ColorPPPaste, nil, -7, 7, 7, -7, false, true)
	ColorPPPaste:SetBackdrop('')
	BORDER:CreateBorder(ColorPPDefault, nil, -7, 7, 7, -7, false, true)
	ColorPPDefault:SetBackdrop('')
	
	BORDER:CreateBorder(ColorPickerFrame.Content.HexBox, nil, -9, 7, 8, -7, true)
end

S:AddCallback('BlizzardMiscFrames')
