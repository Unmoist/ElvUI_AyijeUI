local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local ACH = E.Libs.ACH

function AYIJE:Minimapbuttons()
  local AOA = AYIJE.Options.args

	AOA.minimapbutton = ACH:Group(L["Minimap Buttons"], nil, 10, nil, function(info) return E.db.AYIJE.minimapbutton[ info[#info] ] end, function(info, value) E.db.AYIJE.minimapbutton[ info[#info] ] = value; MB:UpdateLayout() end)

	local AOAMB = AOA.minimapbutton.args

	AOAMB.desc = ACH:Group(L["Description"], nil, 1)
	AOAMB.desc.inline = true
	AOAMB.desc.args.feature = ACH:Description(L["Add an extra bar to collect minimap buttons."], 1, "medium")
	AOAMB.enable = ACH:Toggle(L["Enable"], L["Toggle minimap buttons bar"], 2, nil, false, nil, nil, function(info, value) E.db.AYIJE.minimapbutton.enable = value; E:StaticPopup_Show("AYIJE_RL") end)
	AOAMB.spacer = ACH:Header(L[""], 2)
	AOAMB.skinStyle = ACH:Select(L["Skin Style"], L["Change settings for how the minimap buttons are skinned"], 2, MiniMapButtonSelect, false, nil, nil, function(info, value) E.db.AYIJE.minimapbutton[ info[#info] ] = value; MB:UpdateSkinStyle() end, function() return not E.db.AYIJE.minimapbutton.enable end)
	AOAMB.layoutDirection = ACH:Select(L['Layout Direction'], L['Normal is right to left or top to bottom, or select reversed to switch directions.'], 3, MiniMapButtonDirection, false, nil, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	AOAMB.buttonSize = ACH:Range(L['Button Size'], L['The size of the minimap buttons.'], 4, { min = 16, max = 40, step = 1 }, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	AOAMB.buttonsPerRow = ACH:Range(L['Buttons per row'], L['The max number of buttons when a new row starts'], 5, { min = 4, max = 20, step = 1 }, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	AOAMB.backdrop = ACH:Toggle(L['Backdrop'], nil, 6, nil, false, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	AOAMB.border = ACH:Toggle(L['Border for Icons'], nil, 7, nil, false, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable end)
	AOAMB.mouseover = ACH:Toggle(L['Mouse Over'], L['The frame is not shown unless you mouse over the frame.'], 7, nil, false, nil, nil, function(info, value) E.db.AYIJE.minimapbutton.mouseover = value; MB:ChangeMouseOverSetting() end, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	
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
