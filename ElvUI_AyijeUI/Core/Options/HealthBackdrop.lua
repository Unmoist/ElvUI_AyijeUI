local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local ACH = E.Libs.ACH

function AYIJE:HealthBackdrop()
  local AOA = AYIJE.Options.args

	AOA.cbackdrop = ACH:Group(L["Health Backdrop"], nil, 10)

	local AOACB = AOA.cbackdrop.args

	AOACB.desc = ACH:Group(L["Description"], nil, 1)
	AOACB.desc.inline = true
	AOACB.desc.args.feature = ACH:Description(L["Changes the health backdrop texture."], 1, "medium")
	AOACB.spacer = ACH:Header(L[""], 2)
	AOACB.custom = ACH:Toggle(L["Enable"], nil, 3, nil, false, nil,function() return E.db.AYIJE.cbackdrop.Backdrop end,function(_, value) E.db.AYIJE.cbackdrop.Backdrop = value E:StaticPopup_Show('AYIJE_RL'); AYIJE:CustomHealthBackdrop() end)
	AOACB.customtexture = ACH:SharedMediaStatusbar(L["Backdrop Texture"], L["Select a Texture"], 4, nil, function() return E.db.AYIJE.cbackdrop.customtexture end, function(_,key) E.db.AYIJE.cbackdrop.customtexture = key E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.cbackdrop.Backdrop end)

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
