local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local ACH = E.Libs.ACH

function AYIJE:Minimapid()
  local AOA = AYIJE.Options.args

	AOA.minimapid = ACH:Group(L["Minimap Instance Difficulty"], nil, 10, nil, function(info) return E.db.AYIJE.minimapid [info[#info]] end, function(info, value) E.db.AYIJE.minimapid[info[#info]] = value E:StaticPopup_Show("AYIJE_RL") end, nil, nil, nil)

	local AOAMI = AOA.minimapid.args

	AOAMI.desc = ACH:Group(L["Description"], nil, 1)
	AOAMI.desc.inline = true
	AOAMI.desc.args.feature = ACH:Description(L["Add Instance Difficulty in text format."], 1, "medium")
	AOAMI.spacer = ACH:Header(L[""], 2)
	AOAMI.enable = ACH:Toggle(L["Enable"], nil, 3, nil, nil, nil, nil, nil, nil, nil)
	AOAMI.align = ACH:Select(L["Text Align"], nil, 4, {LEFT = L["Left"], CENTER = L["Center"], RIGHT = L["Right"]}, nil, nil, nil, nil, nil, nil)
	AOAMI.hideBlizzard = ACH:Toggle(L["Hide Blizzard Indicator"], nil, 5, nil, nil, nil, nil, nil, nil, nil)
	AOAMI.font = ACH:Group(L["Font"], nil, 6, nil, function(info) return E.db.AYIJE.minimapid.font[info[#info]] end, function(info, value) E.db.AYIJE.minimapid.font[info[#info]] = value E:StaticPopup_Show("AYIJE_RL") end, nil, nil, nil)
	AOAMI.font.inline = true
	AOAMI.font.args.name = ACH:SharedMediaFont(L["Font"], nil, 1, nil, nil, nil, nil, nil, nil, nil)
	AOAMI.font.args.style = ACH:Select(L["Outline"], nil, 2, {NONE = L["None"], OUTLINE = L["OUTLINE"], THICKOUTLINE = L["THICKOUTLINE"], SHADOW = L["SHADOW"], SHADOWOUTLINE = L["SHADOWOUTLINE"], SHADOWTHICKOUTLINE = L["SHADOWTHICKOUTLINE"], MONOCHROME = L["MONOCHROME"], MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"], MONOCHROMETHICKOUTLINE = L["MONOCHROMETHICKOUTLINE"]}, nil, nil, nil, nil, nil, nil)
	AOAMI.font.args.size = ACH:Range(L["Size"], nil, 3, { min = 5, max = 60, step = 1 }, nil, nil, nil, nil, nil)

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
