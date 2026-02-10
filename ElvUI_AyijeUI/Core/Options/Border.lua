local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local ACH = E.Libs.ACH
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

function AYIJE:Border()
  local AOA = AYIJE.Options.args

	AOA.Skins = ACH:Group(L["Border"], nil, 10, 'tab')

	local AOASS = AOA.Skins.args

	local addonskins = {
		"warpdeplete",
		"bigwigsqueue",
		"details",
		"detailsresize",
		"grid2",
	}

	AOASS.desc = ACH:Header(L["Skins"], 1)
	AOASS.AddOns = ACH:Group(L["AddOns"], nil, 1)
	AOASS.AddOns.args.desc = ACH:Group(L["Description"], nil, 1)
	AOASS.AddOns.args.desc.inline = true
	AOASS.AddOns.args.desc.args.feature = ACH:Description(L["Skins Addons to fit AyijeUI."], 1, "medium")
	AOASS.AddOns.args.spacer = ACH:Header(L[""], 2)
	AOASS.AddOns.args.buttonGroup = ACH:Group(L[""], nil, 3)
	AOASS.AddOns.args.buttonGroup.inline = true
	AOASS.AddOns.args.buttonGroup.args.enableAll = ACH:Execute(L["Enable All"], nil, 1, function() for _, skin in ipairs(addonskins) do E.db.AYIJE.skins[skin] = true end E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.AddOns.args.buttonGroup.args.disableAll = ACH:Execute(L["Disable All"], nil, 2, function() for _, skin in ipairs(addonskins) do E.db.AYIJE.skins[skin] = false end E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.AddOns.args.warpDeplete = ACH:Toggle(L["WarpDeplete"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.warpdeplete end,function(_, value) E.db.AYIJE.skins.warpdeplete = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("WarpDeplete") end)
	AOASS.AddOns.args.bigwigsqueue = ACH:Toggle(L["BigWigs Queue"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.bigwigsqueue end,function(_, value) E.db.AYIJE.skins.bigwigsqueue = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("BigWigs") end)
	AOASS.AddOns.args.details = ACH:Toggle(L["Details"], L["Adds a border, background and separators to Details\n\n|cFFFF0000This will only work 100% with AYIJE Details Profile.|r"], 3, nil, false, nil, function() return E.db.AYIJE.skins.details end,function(_, value) E.db.AYIJE.skins.details = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("Details") end)
	AOASS.AddOns.args.detailsResize = ACH:Toggle(L["Details AutoResizer"], L["Resize Details Window 2 based on Zone type.\n   - Shows 2 players for none/party zone.\n   - Shows 5 players in raid zone."], 3, nil, false, nil, function() return E.db.AYIJE.skins.detailsresize end,function(_, value) E.db.AYIJE.skins.detailsresize = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.skins.details end, function() return not E.db.AYIJE.skins.details end)
	AOASS.AddOns.args.grid2 = ACH:Toggle(L["Grid2"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.grid2 end,function(_, value) E.db.AYIJE.skins.grid2 = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("Grid2") end)

	local elvuiskins = {
		"actionBarsBackdrop",
		"actionBarsButton",
		"afk",
		"altPowerBar",
		"chatDataPanels",
		"chatPanels",
		"chatVoicePanel",
		"chatCopyFrame",
		"lootRoll",
		"options",
		"panels",
		"raidUtility",
		"staticPopup",
		"statusReport",
		"totemTracker",
		"Minimap",
		"Character",
		"Nameplates",
	}

	AOASS.Elvui = ACH:Group(L["ElvUI"], nil, 1)
	AOASS.Elvui.args.desc = ACH:Group(L["Description"], nil, 1)
	AOASS.Elvui.args.desc.inline = true
	AOASS.Elvui.args.desc.args.feature = ACH:Description(L["Skins ElvUi frames to fit AyijeUI."], 1, "medium")
	AOASS.Elvui.args.spacer = ACH:Header(L[""], 2)
	AOASS.Elvui.args.buttonGroup = ACH:Group(L[""], nil, 3)
	AOASS.Elvui.args.buttonGroup.inline = true
	AOASS.Elvui.args.buttonGroup.args.enableAll = ACH:Execute(L["Enable All"], nil, 1, function() for _, skin in ipairs(elvuiskins) do E.db.AYIJE.skins[skin] = true end E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.buttonGroup.args.disableAll = ACH:Execute(L["Disable All"], nil, 2, function() for _, skin in ipairs(elvuiskins) do E.db.AYIJE.skins[skin] = false end E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.actionBarsBackdrop = ACH:Toggle(L["Actionbars Backdrop"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.actionBarsBackdrop end,function(_, value) E.db.AYIJE.skins.actionBarsBackdrop = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.actionBarsButton = ACH:Toggle(L["Actionbars Button"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.actionBarsButton end,function(_, value) E.db.AYIJE.skins.actionBarsButton = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.afk = ACH:Toggle(L["AFK Mode"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.afk end,function(_, value) E.db.AYIJE.skins.afk = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.altPowerBar = ACH:Toggle(L["Alt Power"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.altPowerBar end,function(_, value) E.db.AYIJE.skins.altPowerBar = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.chatDataPanels = ACH:Toggle(L["Chat Data Panels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatDataPanels end,function(_, value) E.db.AYIJE.skins.chatDataPanels = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.chatPanels = ACH:Toggle(L["Chat Panels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatPanels end,function(_, value) E.db.AYIJE.skins.chatPanels = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.chatVoicePanel = ACH:Toggle(L["Chat Voice Panel"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatVoicePanel end,function(_, value) E.db.AYIJE.skins.chatVoicePanel = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.chatCopyFrame = ACH:Toggle(L["Chat Copy Frame"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatCopyFrame end,function(_, value) E.db.AYIJE.skins.chatCopyFrame = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.lootRoll = ACH:Toggle(L["Loot Roll"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.lootRoll end,function(_, value) E.db.AYIJE.skins.lootRoll = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.options = ACH:Toggle(L["Options"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.options end,function(_, value) E.db.AYIJE.skins.options = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.panels = ACH:Toggle(L["Panels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.panels end,function(_, value) E.db.AYIJE.skins.panels = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.raidUtility = ACH:Toggle(L["Raid Utility"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.raidUtility end,function(_, value) E.db.AYIJE.skins.raidUtility = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.staticPopup = ACH:Toggle(L["Static Popup"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.staticPopup end,function(_, value) E.db.AYIJE.skins.staticPopup = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.statusReport = ACH:Toggle(L["Status Report"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.statusReport end,function(_, value) E.db.AYIJE.skins.statusReport = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.totemTracker = ACH:Toggle(L["Totem Tracker"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.totemTracker end,function(_, value) E.db.AYIJE.skins.totemTracker = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.minimap = ACH:Toggle(L["MiniMap"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.Minimap end,function(_, value) E.db.AYIJE.skins.Minimap = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.private.general.minimap.enable end)
	AOASS.Elvui.args.dataPanels = ACH:Toggle(L["DataPanels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.dataPanels end,function(_, value) E.db.AYIJE.skins.dataPanels = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.character = ACH:Toggle(L["Character"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.character end,function(_, value) E.db.AYIJE.skins.character = value E:StaticPopup_Show('AYIJE_RL') end)
	AOASS.Elvui.args.nameplates = ACH:Toggle(L["NamePlates"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.nameplates end,function(_, value) E.db.AYIJE.skins.nameplates = value E:StaticPopup_Show('AYIJE_RL') end)

end

--[[
	ACH:Color(name, desc, order, alpha, width, get, set, disabled, hidden)
	ACH:Description(name, order, fontSize, image, imageCoords, imageWidth, imageHeight, width, hidden)
	ACH:Execute(name, desc, order, func, image, confirm, width, get, set, disabled, hidden)
	ACH:Group(name, desc, order, childGroups, get, set, disabled, hidden, func)
	ACH:Header(name, order, get, set, hidden)
	ACH:Input(name, desc, order, multiline, width, get, set, disabled, hidden, validate)
	ACH:Select(name, desc, order, values, confirm, width, get, set, disabled, hidden, sortByValue)
	ACH:MultiSelect(name, desc, order, values, confirm, width, get, set, disabled, hidden, sortByValue)
	ACH:Toggle(name, desc, order, tristate, confirm, width, get, set, disabled, hidden)
	ACH:Range(name, desc, order, values, width, get, set, disabled, hidden)
	ACH:Spacer(order, width, hidden)
	ACH:SharedMediaFont(name, desc, order, width, get, set, disabled, hidden)
	ACH:SharedMediaSound(name, desc, order, width, get, set, disabled, hidden)
	ACH:SharedMediaStatusbar(name, desc, order, width, get, set, disabled, hidden)
	ACH:SharedMediaBackground(name, desc, order, width, get, set, disabled, hidden)
	ACH:SharedMediaBorder(name, desc, order, width, get, set, disabled, hidden)
	ACH:FontFlags(name, desc, order, width, get, set, disabled, hidden)
]]
