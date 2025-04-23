local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local B = E:GetModule("Bags")

local _G = _G
local pairs = pairs

local GetItemQualityColor = C_Item.GetItemQualityColor or GetItemQualityColor
local ITEMQUALITY_COMMON = Enum.ItemQuality.Common or Enum.ItemQuality.Standard

local ContainerSlot = B.ConstructContainerButton
local UpdateSlotBorder = B.UpdateSlotColors
local ContainerFrameMove = B.ConstructContainerFrame
local Warband_MenuSkin = B.Warband_MenuSkin

--------------------- BAG Skinning, have to be out of the main function -------------------------
function B:ConstructContainerFrame(name, isBank)
	local f = ContainerFrameMove(self, name, isBank)
	--Sort Button
	if f.sortButton then
		f.sortButton:Kill()
	end
	--Toggle Bags Button
	f.bagsButton:Point('RIGHT', f.stackButton, 'LEFT', -5, 0)

	if not isBank then
		--Stack
		f.stackButton:Point('BOTTOMRIGHT', f.holderFrame, 'TOPRIGHT', 0, 7)
		--Vendor Grays
		f.vendorGraysButton:Point('RIGHT', E.Classic and f.keyButton or f.bagsButton, 'LEFT', -5, 0)
		--Bag Search
		f.editBox:Point('BOTTOMLEFT', f.holderFrame, 'TOPLEFT', E.Border, 8)
	end

	BORDER:CreateBorder(f.stackButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.vendorGraysButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.sortButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.bagsButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.depositButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.goldDeposit, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.reagentToggle, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.warbandToggle, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.goldWithdraw, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(f.bankToggle, nil, nil, nil, nil, nil, false, true)
  BORDER:CreateBorder(f.purchaseBagButton, nil, nil, nil, nil, nil, false, true)
  BORDER:CreateBorder(f.warbandDeposit, nil, nil, nil, nil, nil, false, true)        
	BORDER:CreateBorder(f.warbandReagents, nil, nil, nil, nil, nil, true, true)        

	return f
end

function B:ConstructContainerButton(f, bagID, slotID)
	local slot = ContainerSlot(self, f, bagID, slotID)
  BORDER:CreateBorder(slot)
	slot.border:SetBackdrop(Engine.BorderLight)

  return slot
end

function B:UpdateSlotColors(slot, isQuestItem, questId, isActiveQuest)
	UpdateSlotBorder(self, slot, isQuestItem, questId, isActiveQuest)

	local questColors, r, g, b, a = B.db.qualityColors and (questId or isQuestItem) and B.QuestColors[not isActiveQuest and 'questStarter' or 'questItem']
	local qR, qG, qB = E:GetItemQualityColor(slot.rarity)

	if questColors then
		r, g, b, a = unpack(questColors)
	elseif B.db.qualityColors and (slot.rarity and slot.rarity > ITEMQUALITY_COMMON) then
		r, g, b = qR, qG, qB
	else
		local bag = slot.bagFrame.Bags[slot.BagID]
		local colors = bag and ((B.db.specialtyColors and B.ProfessionColors[bag.type]) or (B.db.showAssignedColor and B.AssignmentColors[bag.assigned]))
		if colors then
			r, g, b, a = colors.r, colors.g, colors.b, colors.a
		end
	end

	if not a then a = 1 end
		slot.forcedBorderColors = r and {r, g, b, a}
		if not r then r, g, b = 173/255, 170/255, 169/255 end
	
	slot.border:SetBackdropBorderColor(r, g, b, a)
end

function B:Warband_MenuSkin(menu)
    Warband_MenuSkin(self, menu)
      local deposit = menu.DepositSettingsMenu
      if deposit then
        BORDER:CreateBorder(deposit.ExpansionFilterDropdown, nil, nil, nil, nil, nil, true, true)
        BORDER:CreateBorder(deposit.AssignEquipmentCheckbox, nil, nil, nil, nil, nil, true, true)
				BORDER:CreateBorder(deposit.AssignConsumablesCheckbox, nil, nil, nil, nil, nil, true, true)
				BORDER:CreateBorder(deposit.AssignProfessionGoodsCheckbox, nil, nil, nil, nil, nil, true, true)
				BORDER:CreateBorder(deposit.AssignReagentsCheckbox, nil, nil, nil, nil, nil, true, true)
				BORDER:CreateBorder(deposit.AssignJunkCheckbox, nil, nil, nil, nil, nil, true, true)
				BORDER:CreateBorder(deposit.IgnoreCleanUpCheckbox, nil, nil, nil, nil, nil, true, true)
    end
end
--------------------- BAG Skinning, have to be out of the main function -------------------------

function S:ElvUI_Bags()
	if not E.private.bags.enable then return end

	local ContainerFrame = _G.ElvUI_ContainerFrame
	local BankContainerFrame = _G.ElvUI_BankContainerFrame

	BORDER:CreateBorder(ContainerFrame)
	BORDER:CreateBorder(BankContainerFrame)
	BORDER:CreateBorder(_G.ElvUI_ContainerFrameEditBox.backdrop)
	BORDER:CreateBorder(_G.ElvUI_BankContainerFrameEditBox.backdrop)

	BORDER:CreateBorder(_G.ElvUI_ContainerFrameStackButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(_G.ElvUI_ContainerFrameSortButton, nil, nil, nil, nil, nil, false, true)
	BORDER:CreateBorder(_G.ElvUI_ContainerFrameBagsButton, nil, nil, nil, nil, nil, false, true)

	BORDER:CreateBorder(_G.BankItemSearchBox)
	if E.Retail then
		BORDER:CreateBorder(_G.ReagentBankFrame.DespositButton)

		if _G.ElvUI_BankContainerFrameWarbandHolder.cover then
			BORDER:CreateBorder(_G.ElvUI_BankContainerFrameWarbandHolder.cover)
			BORDER:CreateBorder(_G.ElvUI_BankContainerFrameWarbandHolder.cover.purchaseButton, nil, nil, nil, nil, nil, false, true)
		end

		_G.ElvUI_BankContainerFrameContainerHolder:SetBackdropColor(1, 1, 1, 0)
		_G.ElvUI_BankContainerFrameContainerHolder:SetBackdropBorderColor(1, 1, 1, 0)
	
		_G.ElvUI_BankContainerFrameWarbandHolder:SetBackdropColor(1, 1, 1, 0)
		_G.ElvUI_BankContainerFrameWarbandHolder:SetBackdropBorderColor(1, 1, 1, 0)
	end
	BORDER:CreateBorder(_G.BagItemAutoSortButton)
	BORDER:CreateBorder(_G.BankItemAutoSortButton)

	for i = 0, 12 do
		local BankBag = _G["ElvUIBankBag" ..i]
		BORDER:CreateBorder(BankBag)
	end


end

S:AddCallback("ElvUI_Bags")