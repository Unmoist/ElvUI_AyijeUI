local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local FLYOUT_LOCATIONS = {
	[0xFFFFFFFF] = 'PLACEINBAGS',
	[0xFFFFFFFE] = 'IGNORESLOT',
	[0xFFFFFFFD] = 'UNIGNORESLOT'
}

local function EquipmentDisplayButton(button)
	if not button.isHooked then
		button:SetNormalTexture(E.ClearTexture)
		button:SetPushedTexture(E.ClearTexture)
		button:SetTemplate()
		button:StyleButton()

		button.icon:SetInside()
		button.icon:SetTexCoord(unpack(E.TexCoords))

    
    BORDER:CreateBorder(button)
		button.border:SetBackdrop(Engine.BorderLight)

    S:HandleIconBorder(button.IconBorder, button.border)

		button.isHooked = true
	end

	if FLYOUT_LOCATIONS[button.location] then -- special slots
		button:SetBackdropBorderColor(unpack(E.media.bordercolor))
    button.border:SetBackdrop(Engine.BorderLight)
    button.border:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	end
end


local function EquipmentUpdateItems()
	local frame = _G.EquipmentFlyoutFrame.buttonFrame
	if not frame.template then
		frame:StripTextures()
		frame:SetTemplate('Transparent')
	end

	local width, height = frame:GetSize()
	frame:Size(width+3, height)

	for _, button in next, _G.EquipmentFlyoutFrame.buttons do
		EquipmentDisplayButton(button)
	end
end

local function EquipmentUpdateNavigation()
	local navi = _G.EquipmentFlyoutFrame.NavigationFrame
	if not navi then return end

	navi:ClearAllPoints()
	navi:Point('TOPLEFT', _G.EquipmentFlyoutFrameButtons, 'BOTTOMLEFT', 0, -E.Border - E.Spacing)
	navi:Point('TOPRIGHT', _G.EquipmentFlyoutFrameButtons, 'BOTTOMRIGHT', 0, -E.Border - E.Spacing)

	navi:StripTextures()
	navi:SetTemplate('Transparent')
end

local function TabTextureCoords(tex, x1)
	if x1 ~= 0.16001 then
		tex:SetTexCoord(0.16001, 0.86, 0.16, 0.86)
	end
end

function S:Blizzard_UIPanels_Game()
    if CharacterFrame:IsShown() then
      HideUIPanel(CharacterFrame)
    end

    --CharacterFrame:SetScale(1.1)

    local s_upper = _G.string.upper
  local SLOT_TEXTURES_TO_REMOVE = {
      ["410248"] = true,
      ["INTERFACE\\CHARACTERFRAME\\CHAR-PAPERDOLL-PARTS"] = true,
  }
  for slot in next, {
      [CharacterBackSlot] = true,
      [CharacterChestSlot] = true,
      [CharacterFeetSlot] = false,
      [CharacterFinger0Slot] = false,
      [CharacterFinger1Slot] = false,
      [CharacterHandsSlot] = false,
      [CharacterHeadSlot] = true,
      [CharacterLegsSlot] = false,
      [CharacterMainHandSlot] = false,
      [CharacterNeckSlot] = true,
      [CharacterSecondaryHandSlot] = true,
      [CharacterShirtSlot] = true,
      [CharacterShoulderSlot] = true,
      [CharacterTabardSlot] = true,
      [CharacterTrinket0Slot] = false,
      [CharacterTrinket1Slot] = false,
      [CharacterWaistSlot] = false,
      [CharacterWristSlot] = true,
  } do
      for _, v in next, {slot:GetRegions()} do
          if v:IsObjectType("Texture") and SLOT_TEXTURES_TO_REMOVE[s_upper(v:GetTexture() or "")] then
              v:SetTexture(0)
              v:Hide()
          end
      end
      slot:SetSize(36,36)
  end

  CharacterHeadSlot:SetPoint("TOPLEFT", CharacterFrame.Inset, "TOPLEFT", 6, -6)
  CharacterHandsSlot:SetPoint("TOPRIGHT", CharacterFrame.Inset, "TOPRIGHT", -6, -6)
  CharacterMainHandSlot:SetPoint("BOTTOMLEFT", CharacterFrame.Inset, "BOTTOMLEFT", 176, 5)
  CharacterSecondaryHandSlot:ClearAllPoints()
  CharacterSecondaryHandSlot:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, "BOTTOMRIGHT", -176, 5)

  CharacterModelScene:SetSize(300, 360)
  CharacterModelScene:ClearAllPoints()
  CharacterModelScene:SetPoint("TOPLEFT", CharacterFrame.Inset, 64, -3)


  for _, texture in next, {
      CharacterModelScene.BackgroundBotLeft,
      CharacterModelScene.BackgroundBotRight,
      CharacterModelScene.BackgroundOverlay,
      CharacterModelScene.BackgroundTopLeft,
      CharacterModelScene.BackgroundTopRight,
      CharacterStatsPane.ClassBackground,
      PaperDollInnerBorderBottom,
      PaperDollInnerBorderBottom2,
      PaperDollInnerBorderBottomLeft,
      PaperDollInnerBorderBottomRight,
      PaperDollInnerBorderLeft,
      PaperDollInnerBorderRight,
      PaperDollInnerBorderTop,
      PaperDollInnerBorderTopLeft,
      PaperDollInnerBorderTopRight,
  } do
      texture:SetTexture(nil)
      texture:Hide()
  end

  --[[
  hooksecurefunc("CharacterFrame_Expand", function()
          CharacterFrame:SetSize(640, 431)
          CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 432, 4)
          
  end)

  hooksecurefunc("CharacterFrame_Collapse", function()
          CharacterFrame:SetHeight(424)
          CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 332, 4)
          
          CharacterFrame.Inset.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble", "REPEAT", "REPEAT")
          CharacterFrame.Inset.Bg:SetTexCoord(0, 1, 0, 1)
          CharacterFrame.Inset.Bg:SetHorizTile(true)
          CharacterFrame.Inset.Bg:SetVertTile(true)
  end)
  --]]

  for _, Slot in next, { _G.PaperDollItemsFrame:GetChildren() } do
		if Slot:IsObjectType('Button') or Slot:IsObjectType('ItemButton') then
			S:HandleIcon(Slot.icon)
			Slot:StripTextures()
			Slot:SetTemplate()
			Slot:StyleButton(Slot)
			Slot.icon:SetInside()
			Slot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])

			--S:HandleIconBorder(Slot.IconBorder)

			if Slot.popoutButton:GetPoint() == 'TOP' then
				Slot.popoutButton:Point('TOP', Slot, 'BOTTOM', 0, 2)
			else
				Slot.popoutButton:Point('LEFT', Slot, 'RIGHT', -2, 0)
			end

			E:RegisterCooldown(_G[Slot:GetName()..'Cooldown'])
			BORDER:CreateBorder(Slot)
			BORDER:HandleIconBorder(Slot.IconBorder, Slot.border)
      

		end
	end

  _G.EquipmentFlyoutFrameHighlight:StripTextures()
	_G.EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
	_G.EquipmentFlyoutFrameButtons:DisableDrawLayer('ARTWORK')
	hooksecurefunc('EquipmentFlyout_SetBackgroundTexture', EquipmentUpdateNavigation)
	hooksecurefunc('EquipmentFlyout_UpdateItems', EquipmentUpdateItems) -- Swap item flyout frame (shown when holding alt over a slot)

  PaperDollFrame.TitleManagerPane:SetSize(0, 0)
  PaperDollFrame.TitleManagerPane:SetPoint("TOPLEFT", CharacterFrame.InsetRight, "TOPLEFT", 3, -2)
  PaperDollFrame.TitleManagerPane:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, "BOTTOMRIGHT", -21, 4)

  PaperDollFrame.TitleManagerPane.ScrollBox:SetSize(0, 0)
  PaperDollFrame.TitleManagerPane.ScrollBox:SetPoint("TOPLEFT", CharacterFrame.InsetRight, "TOPLEFT", 3, -4)
  PaperDollFrame.TitleManagerPane.ScrollBox:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, "BOTTOMRIGHT", -26, 4)

  PaperDollFrame.TitleManagerPane.ScrollBar:ClearAllPoints()
  PaperDollFrame.TitleManagerPane.ScrollBar:SetPoint("TOPRIGHT", CharacterFrame.InsetRight, "TOPRIGHT", -10, -8)
  PaperDollFrame.TitleManagerPane.ScrollBar:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, "BOTTOMRIGHT", -10, 6)

  hooksecurefunc("PaperDollTitlesPane_InitButton", function(button)
          button.BgTop:Hide()
          button.BgMiddle:Hide()
          button.BgBottom:Hide()
  end)

  PaperDollFrame.EquipmentManagerPane.EquipSet:SetPoint("TOPLEFT", 2, -2)

  PaperDollFrame.EquipmentManagerPane:SetSize(0, 0)
  PaperDollFrame.EquipmentManagerPane:SetPoint("TOPLEFT", CharacterFrame.InsetRight, "TOPLEFT", 3, -2)
  PaperDollFrame.EquipmentManagerPane:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, "BOTTOMRIGHT", -21, 4)

  PaperDollFrame.EquipmentManagerPane.ScrollBox:SetSize(0, 0)
  PaperDollFrame.EquipmentManagerPane.ScrollBox:SetPoint("TOPLEFT", CharacterFrame.InsetRight, "TOPLEFT", 3, -28)
  PaperDollFrame.EquipmentManagerPane.ScrollBox:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, "BOTTOMRIGHT", -26, 4)

  PaperDollFrame.EquipmentManagerPane.ScrollBar:ClearAllPoints()
  PaperDollFrame.EquipmentManagerPane.ScrollBar:SetPoint("TOPRIGHT", CharacterFrame.InsetRight, "TOPRIGHT", -10, -8)
  PaperDollFrame.EquipmentManagerPane.ScrollBar:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, "BOTTOMRIGHT", -10, 6)

  hooksecurefunc("PaperDollEquipmentManagerPane_InitButton", function(button)
          button.BgTop:Hide()
          button.BgMiddle:Hide()
          button.BgBottom:Hide()
  end)

  hooksecurefunc(CharacterFrame, "UpdateSize", function()
          if CharacterFrame.activeSubframe == "PaperDollFrame" then
              CharacterFrame:SetSize(640, 431) -- 540 + 100, 424 + 7
              CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 432, 4)
              
              --CharacterFrame.Inset.Bg:SetTexture("Interface\\DressUpFrame\\DressingRoom")
              CharacterFrame.Inset.Bg:SetTexCoord(1 / 512, 479 / 512, 46 / 512, 455 / 512)
              CharacterFrame.Inset.Bg:SetHorizTile(false)
              CharacterFrame.Inset.Bg:SetVertTile(false)
              
              CharacterFrame.Background:Hide()
              
          else
              CharacterFrame.Background:Show()
          end
  end)
end

S:AddCallbackForAddon('Blizzard_UIPanels_Game')
