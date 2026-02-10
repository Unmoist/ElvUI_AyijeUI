local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local ACH = E.Libs.ACH

function AYIJE:Rectangleminimap()
  local AOA = AYIJE.Options.args

	AOA.rectangleminimap = ACH:Group(L["Rectangle Minimap"], nil, 10)
	local AOARM = AOA.rectangleminimap.args

	AOARM.desc = ACH:Group(L["Description"], nil, 1)
	AOARM.desc.inline = true
	AOARM.desc.args.feature = ACH:Description(L["Makes the Minimap Rectangle."], 1, "medium")
	AOARM.spacer = ACH:Header(L[""], 2)
	AOARM.minimapret = ACH:Toggle(L["Enable"], L["Toggle Rectangle Minimap."], 2, nil, false, nil,function() return E.db.AYIJE.minimap.Rectangle end,function(_, value) E.db.AYIJE.minimap.Rectangle = value E:StaticPopup_Show('AYIJE_RL') end)
	
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
