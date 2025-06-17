local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local TT = E:GetModule('Tooltip')

local _G = _G
local next = next
local TooltipDataType = Enum.TooltipDataType
local AddTooltipPostCall = TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall
local GetDisplayedItem = TooltipUtil and TooltipUtil.GetDisplayedItem
local GameTooltip, GameTooltipStatusBar = GameTooltip, GameTooltipStatusBar

function BORDER:TT_SetStyle(tt)
	if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
		if not tt.border then
			BORDER:CreateBorder(tt, nil, -8, 7.5, 8, -8)
		end
	end
end

function BORDER:GameTooltip_OnTooltipSetItem(data)
	if (self ~= GameTooltip and self ~= _G.ShoppingTooltip1 and self ~= _G.ShoppingTooltip2) or self:IsForbidden() or not TT.db.visibility then return end
	local owner = self:GetOwner()
	local ownerName = owner and owner.GetName and owner:GetName()
	if ownerName and (strfind(ownerName, 'ElvUI_Container') or strfind(ownerName, 'ElvUI_BankContainer')) and not TT:IsModKeyDown(TT.db.visibility.bags) then
		self:Hide()
		return
	end

	local itemID, bagCount, bankCount
	local modKey = TT:IsModKeyDown()

	local GetItem = GetDisplayedItem or self.GetItem
	if GetItem then
		local name, link = GetItem(self)
		if name and link then
			local _, _, itemQuality = GetItemInfo(link)
			local r, g, b = GetItemQualityColor(itemQuality)
			
			if self.border then
				self.border:SetBackdrop(Engine.BorderLight)
				self.border:SetBackdropBorderColor(r, g, b)
			end
		end
	end
end

function BORDER:TT_GameTooltip_SetDefaultAnchor(tt)
	if tt.StatusBar and tt.StatusBar.backdrop then
			if not tt.StatusBar.backdrop.border then
					BORDER:CreateBorder(tt.StatusBar.backdrop)
			end
	end
end

function BORDER:TT_GameTooltip_ShowProgressBar(tt)
	if not tt or not tt.progressBarPool or tt:IsForbidden() then return end

	local sb = tt.progressBarPool:GetNextActive()
	if not sb or not sb.Bar then return end

	tt.progressBar = sb.Bar

	if not sb.Bar.backdrop then
		sb.Bar:StripTextures()
		sb.Bar:CreateBackdrop('Transparent', nil, true)
		sb.Bar:SetStatusBarTexture(E.media.normTex)
	end

	if not sb.Bar.backdrop.border then
		BORDER:CreateBorder(sb.Bar.backdrop)
	end
end

local function StyleTooltips()       
	local styleTT = {
		_G.AceConfigDialogTooltip,
		_G.AceGUITooltip,
		_G.BattlePetTooltip,
		_G.DataTextTooltip,
		_G.ElvUIConfigTooltip,
		_G.ElvUISpellBookTooltip,
		_G.EmbeddedItemTooltip,
		_G.FriendsTooltip,
		_G.FloatingBattlePetTooltip,
		_G.GameSmallHeaderTooltip,
		_G.GameTooltip,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.ItemRefTooltip,
		_G.LibDBIconTooltip,
		_G.QuestScrollFrame and _G.QuestScrollFrame.CampaignTooltip,
		_G.QuestScrollFrame and _G.QuestScrollFrame.StoryTooltip,
		_G.QuickKeybindTooltip,
		_G.ReputationParagonTooltip,
		_G.SettingsTooltip,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
		_G.WarCampaignTooltip
	}

	for _, tt in pairs(styleTT) do
		if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
				BORDER:TT_SetStyle(tt)
		end
	end

	BORDER:SecureHook(TT, "SetStyle", BORDER.TT_SetStyle)
	BORDER:SecureHook(TT, "GameTooltip_SetDefaultAnchor", BORDER.TT_GameTooltip_SetDefaultAnchor)
	BORDER:SecureHook(_G.QueueStatusFrame, "Update", BORDER.CreateBorder)
	BORDER:SecureHook(TT, "GameTooltip_ShowProgressBar", BORDER.TT_GameTooltip_ShowProgressBar)

	AddTooltipPostCall(TooltipDataType.Item, BORDER.GameTooltip_OnTooltipSetItem)
	_G.GameTooltip:HookScript("OnTooltipCleared", function(frame)
		frame.border:SetBackdrop(Engine.Border)
		frame.border:SetBackdropBorderColor(1, 1, 1) -- Reset to original color
	end)
end

function S:TooltipFrames()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tooltip) then return end

	StyleTooltips()
	--BORDER:CreateBorder(_G.GameTooltip)
	local ItemTT = _G.GameTooltip.ItemTooltip

	BORDER:HandleIcon(ItemTT.Icon)
	BORDER:HandleIconBorder(ItemTT.IconBorder, ItemTT.Icon.backdrop.border)
	if ItemTT.IconBorder then
		ItemTT.IconBorder:Hide()
	end
	
	-- EmbeddedItemTooltip (also Paragon Reputation)
	local EmbeddedTT = _G.EmbeddedItemTooltip.ItemTooltip
	BORDER:HandleIcon(EmbeddedTT.Icon)
	BORDER:HandleIconBorder(EmbeddedTT.IconBorder, EmbeddedTT.Icon.backdrop.border)
	if EmbeddedTT.IconBorder then
		EmbeddedTT.IconBorder:Hide()
	end
end

S:AddCallback('TooltipFrames')
