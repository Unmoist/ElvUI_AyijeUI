local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local ACH = E.Libs.ACH

function AYIJE:ManaFrame()
  local AOA = AYIJE.Options.args

	AOA.ManaFrame = ACH:Group(L["Mana Frame"], nil, 10)
	local AOAMF = AOA.ManaFrame.args

	AOAMF.desc = ACH:Group(L["Description"], nil, 1)
	AOAMF.desc.inline = true
	AOAMF.desc.args.feature = ACH:Description(L["Enables the unique mana frame "], 1, "medium")
	AOAMF.spacer = ACH:Header(L[""], 2)
	AOAMF.enable = ACH:Toggle(L["Enable"], L["Toggle Mana frame."], 2, nil, false, nil, function() return E.db.AYIJE.manaFrame.enable end,function(_, value) E.db.AYIJE.manaFrame.enable = value E:StaticPopup_Show('AYIJE_RL') end)
	AOAMF.glowline = ACH:Toggle(L["Glowline"], L["Toggle Mana Glowline."], 2, nil, false, nil, function() return E.db.AYIJE.manaFrame.glowline end,function(_, value) E.db.AYIJE.manaFrame.glowline = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)
	AOAMF.width = ACH:Range(L["Width"], nil, 4, { min = 0, max = 200, step = 1 }, "full", function() return E.db.AYIJE.manaFrame.width end, function(_, value) E.db.AYIJE.manaFrame.width = value; E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)
	AOAMF.height = ACH:Range(L["Height"], nil, 5, { min = 16, max = 200, step = 1 }, "full", function() return E.db.AYIJE.manaFrame.height end, function(_, value) E.db.AYIJE.manaFrame.height = value; E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)
	AOAMF.text = ACH:Range(L["Text Size"], nil, 6, { min = 0, max = 100, step = 1 }, "full", function() return E.db.AYIJE.manaFrame.textsize end, function(_, value) E.db.AYIJE.manaFrame.textsize = value; E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)

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
