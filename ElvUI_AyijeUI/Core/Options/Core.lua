local AddonName, Engine = ...
local E, _, V, P, G = unpack(ElvUI)
local D = E:GetModule('Distributor')
local PI = E:GetModule('PluginInstaller')

local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale)
local LSM = E.Libs.LSM
local ACH = E.Libs.ACH

local pairs, sort = pairs, sort
local format = format
local tconcat, tinsert = table.concat, table.insert

local PLUGINSUPPORT = { 
	E:TextGradient('Unmoist', 0.6, 0.6, 0.6, 1, 0.78, 0.03),
}

local function SortList(a, b)
	return E:StripString(a) < E:StripString(b)
end

sort(PLUGINSUPPORT, SortList)

for _, name in pairs(PLUGINSUPPORT) do
	tinsert(Engine.Credits, name)
end
Engine.PLUGINSUPPORT_STRING = tconcat(PLUGINSUPPORT, '|n')

function AYIJE:Config()
	E.Options.name = format('%s + %s |cff99ff33%.2f|r', E.Options.name, Engine.Name, Engine.Version)

  AYIJE.Options = ACH:Group("|TInterface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\ajlogo.tga:14:14:0:0|t" .. Engine.Name, nil, 20)
	local AOA = AYIJE.Options.args

	-- Header
	--AOA.logo = ACH:Description(nil, 1, nil, 'Interface\\AddOns\\\\Media\\Textures\\ with banner.tga', nil, 256, 256)
	
  -- Spacer
	AOA.header = ACH:Spacer(2, 'full')

  -- information
	AOA.information = ACH:Group(E:TextGradient(L["Information"], 0.6, 0.6, 0.6, 0.63, 0.62, 0.58), nil, 1)
	AOA.information.args.header = ACH:Header(L["Information"], 1)
	AOA.information.args.spacer = ACH:Spacer(2, 'full')
	AOA.information.args.contact = ACH:Group(L["Message From the Author"], nil, 1)
	AOA.information.args.contact.inline = true
	AOA.information.args.contact.args.description = ACH:Description(format("%s", format(L["Thank you for using %s!"], Engine.Name), format(L["You can send your suggestions or bugs via %s suggestions or help channel."], "|cff5865f2" .. L["Discord"] .. "|r")), 1, "medium")
	AOA.information.args.contact.args.discord = ACH:Execute(format('|cff5865f2%s|r', L["Discord"]), nil, 4, function() E:StaticPopup_Show("AYIJE_EDITBOX", nil, nil, "https://discord.gg/Rexf3DhnBD") end, 'Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\discordlogo.tga', nil, 0.7)
	AOA.information.args.pluginsupport = ACH:Group(L["Plugin and Module Support"], nil, 3)
	AOA.information.args.pluginsupport.inline = true
	AOA.information.args.pluginsupport.args.desc = ACH:Description(Engine.PLUGINSUPPORT_STRING, 1, 'medium')

	--line break so these non options are not with the others
	AOA.linebreak3 = ACH:Group(" ", nil, 2)
	AOA.linebreak3.disabled = true

	-- Modules
	AOA.Modules1 = ACH:Group(L["Modules"], nil, 2)
	AOA.Modules1.disabled = true

	local Auras = E.Options.args.auras

	Auras.args.buffs.args.sizeGroup = ACH:Group(L["Size"], nil, -3)
	Auras.args.buffs.args.sizeGroup.inline = true
	Auras.args.buffs.args.sizeGroup.args.keepSizeRatio = ACH:Toggle(L["Keep Size Ratio"], nil, 1)
	Auras.args.buffs.args.sizeGroup.args.height = ACH:Range(L["Icon Height"], nil, 5, { min = 16, max = 60, step = 2 }, nil, nil, nil, nil, function() return E.db.auras['buffs'].keepSizeRatio end)
	Auras.args.buffs.args.sizeGroup.args.size = ACH:Range(function() return E.db.auras['buffs'].keepSizeRatio and L["Size"] or L["Icon Width"] end, L["Set the size of the individual auras."], 5, { min = 16, max = 60, step = 2 })
	Auras.args.buffs.args.size.hidden = true

	Auras.args.debuffs.args.sizeGroup = ACH:Group(L["Size"], nil, -3)
	Auras.args.debuffs.args.sizeGroup.inline = true
	Auras.args.debuffs.args.sizeGroup.args.keepSizeRatio = ACH:Toggle(L["Keep Size Ratio"], nil, 1)
	Auras.args.debuffs.args.sizeGroup.args.height = ACH:Range(L["Icon Height"], nil, 5, { min = 16, max = 60, step = 2 }, nil, nil, nil, nil, function() return E.db.auras['buffs'].keepSizeRatio end)
	Auras.args.debuffs.args.sizeGroup.args.size = ACH:Range(function() return E.db.auras['debuffs'].keepSizeRatio and L["Size"] or L["Icon Width"] end, L["Set the size of the individual auras."], 5, { min = 16, max = 60, step = 2 })
	Auras.args.debuffs.args.size.hidden = true

  -- Making it Global. 
  E.Options.args.AYIJE = AYIJE.Options

  -- Modules
	AYIJE:ManaFrame()
	AYIJE:Rectangleminimap()
	AYIJE:Minimapbuttons()
	AYIJE:Minimapid()
  AYIJE:HealthBackdrop()
	AYIJE:UnitFrames()
  AYIJE:Border()

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