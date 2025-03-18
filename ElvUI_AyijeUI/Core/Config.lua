local AddonName, Engine = ...
local E, _, V, P, G = unpack(ElvUI)
local D = E:GetModule('Distributor');
local PI = E:GetModule('PluginInstaller');

local LSM = E.Libs.LSM

local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale)
local pairs, sort = pairs, sort
local format, tonumber, tostring = format, tonumber, tostring
local tconcat, tinsert = table.concat, table.insert
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local GetCVar, GetCVarBool = GetCVar, GetCVarBool
local SetCVar = SetCVar
local MiniMapButtonSelect = {NOANCHOR = 'No Anchor Bar', HORIZONTAL = 'Horizontal', VERTICAL = 'Vertical'}
local MiniMapButtonDirection = {NORMAL = 'Normal', REVERSED = 'Reversed'}
local PORTRAITANCHORPOINT = {RIGHT = 'Right', LEFT, 'Right'}

local PLUGINSUPPORT = { 
	E:TextGradient('Unmoist', 0.6, 0.6, 0.6, 1, 0.78, 0.03),
}

local function CheckRaid()
	if tonumber(GetCVar('RAIDsettingsEnabled')) == 0 then
		return true
	end
end

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

	-- LibAceConfigHelper
	local ACH = E.Libs.ACH
	AYIJE.Options = ACH:Group(Engine.Name, nil, 20)

	local ayijeoptions = AYIJE.Options.args
	-- Spacer
	ayijeoptions.header = ACH:Spacer(2, 'full')

	-- information
	ayijeoptions.information = ACH:Group(format('|cfd9b9b9b%s|r', L["Information"]), nil, 1)
	ayijeoptions.information.args.header = ACH:Header(L["Information"], 1)
	ayijeoptions.information.args.spacer = ACH:Spacer(2, 'full')

	ayijeoptions.information.args.contact = ACH:Group(L["Message From the Author"], nil, 1)
	ayijeoptions.information.args.contact.inline = true
	ayijeoptions.information.args.contact.args.description = ACH:Description(
		format("%s\n%s", 
		format(L["Thank you for using %s!"], 
		Engine.Name), 
		format(L["You can send your suggestions or bugs via %s suggestions or help channel."], 
		"|cff5865f2" .. L["Discord"] .. "|r")), 
			1, 
			"medium")
	ayijeoptions.information.args.contact.args.discord = ACH:Execute(format('|cff5865f2%s|r', L["Discord"]), nil, 4, function() E:StaticPopup_Show("AYIJE_EDITBOX", nil, nil, "https://discord.gg/sTGGNEBtnJ") end, 'Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\discordlogo', nil, 0.7)

	ayijeoptions.information.args.pluginsupport = ACH:Group(L["Plugin and Module Support"], nil, 3)
	ayijeoptions.information.args.pluginsupport.inline = true
	ayijeoptions.information.args.pluginsupport.args.desc = ACH:Description(Engine.PLUGINSUPPORT_STRING, 1, 'medium')

	--line break so these non options are not with the others
	ayijeoptions.linebreak3 = ACH:Group(" ", nil, 2)
	ayijeoptions.linebreak3.disabled = true

	-- Modules
	ayijeoptions.Modules = ACH:Group(L["Modules"], nil, 3, 'tab')
	ayijeoptions.Modules.args.desc = ACH:Header(L["Modules"], 1)

	ayijeoptions.Modules.args.manaframe = ACH:Group(L["Mana Frame"], nil, 1)
	ayijeoptions.Modules.args.manaframe.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.Modules.args.manaframe.args.desc.inline = true
	ayijeoptions.Modules.args.manaframe.args.desc.args.feature = ACH:Description(L["Enables the unique mana frame "], 1, "medium")
	ayijeoptions.Modules.args.manaframe.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.Modules.args.manaframe.args.enable = ACH:Toggle(L["Enable"], L["Toggle Mana frame."], 2, nil, false, nil, function() return E.db.AYIJE.manaFrame.enable end,function(_, value) E.db.AYIJE.manaFrame.enable = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Modules.args.manaframe.args.glowline = ACH:Toggle(L["Glowline"], L["Toggle Mana Glowline."], 2, nil, false, nil, function() return E.db.AYIJE.manaFrame.glowline end,function(_, value) E.db.AYIJE.manaFrame.glowline = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)
	ayijeoptions.Modules.args.manaframe.args.width = ACH:Range(L["Width"], nil, 4, { min = 0, max = 200, step = 1 }, "full", function() return E.db.AYIJE.manaFrame.width end, function(_, value) E.db.AYIJE.manaFrame.width = value; E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)
	ayijeoptions.Modules.args.manaframe.args.height = ACH:Range(L["Height"], nil, 5, { min = 16, max = 200, step = 1 }, "full", function() return E.db.AYIJE.manaFrame.height end, function(_, value) E.db.AYIJE.manaFrame.height = value; E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)
	ayijeoptions.Modules.args.manaframe.args.text = ACH:Range(L["Text Size"], nil, 6, { min = 0, max = 100, step = 1 }, "full", function() return E.db.AYIJE.manaFrame.textsize end, function(_, value) E.db.AYIJE.manaFrame.textsize = value; E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.manaFrame.enable end, function() return not E.db.AYIJE.manaFrame.enable end)

	ayijeoptions.Modules.args.minimap = ACH:Group(L["Rectangle Minimap"], nil, 2)
	ayijeoptions.Modules.args.minimap.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.Modules.args.minimap.args.desc.inline = true
	ayijeoptions.Modules.args.minimap.args.desc.args.feature = ACH:Description(L["Makes the Minimap Rectangle."], 1, "medium")
	ayijeoptions.Modules.args.minimap.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.Modules.args.minimap.args.minimapret = ACH:Toggle(L["Enable"], L["Toggle Rectangle Minimap."], 2, nil, false, nil,function() return E.db.AYIJE.minimap.Rectangle end,function(_, value) E.db.AYIJE.minimap.Rectangle = value E:StaticPopup_Show('AYIJE_RL') end)
	
	ayijeoptions.Modules.args.minimapbutton = ACH:Group(L["Minimap Buttons"], nil, 3, nil, function(info) return E.db.AYIJE.minimapbutton[ info[#info] ] end, function(info, value) E.db.AYIJE.minimapbutton[ info[#info] ] = value; MB:UpdateLayout() end)
	ayijeoptions.Modules.args.minimapbutton.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.Modules.args.minimapbutton.args.desc.inline = true
	ayijeoptions.Modules.args.minimapbutton.args.desc.args.feature = ACH:Description(L["Add an extra bar to collect minimap buttons."], 1, "medium")
	ayijeoptions.Modules.args.minimapbutton.args.enable = ACH:Toggle(L["Enable"], L["Toggle minimap buttons bar"], 2, nil, false, nil, nil, function(info, value) E.db.AYIJE.minimapbutton.enable = value; E:StaticPopup_Show("AYIJE_RL") end)
	ayijeoptions.Modules.args.minimapbutton.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.Modules.args.minimapbutton.args.skinStyle = ACH:Select(L["Skin Style"], L["Change settings for how the minimap buttons are skinned"], 2, MiniMapButtonSelect, false, nil, nil, function(info, value) E.db.AYIJE.minimapbutton[ info[#info] ] = value; MB:UpdateSkinStyle() end, function() return not E.db.AYIJE.minimapbutton.enable end)
	ayijeoptions.Modules.args.minimapbutton.args.layoutDirection = ACH:Select(L['Layout Direction'], L['Normal is right to left or top to bottom, or select reversed to switch directions.'], 3, MiniMapButtonDirection, false, nil, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	ayijeoptions.Modules.args.minimapbutton.args.buttonSize = ACH:Range(L['Button Size'], L['The size of the minimap buttons.'], 4, { min = 16, max = 40, step = 1 }, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	ayijeoptions.Modules.args.minimapbutton.args.buttonsPerRow = ACH:Range(L['Buttons per row'], L['The max number of buttons when a new row starts'], 5, { min = 4, max = 20, step = 1 }, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	ayijeoptions.Modules.args.minimapbutton.args.backdrop = ACH:Toggle(L['Backdrop'], nil, 6, nil, false, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	ayijeoptions.Modules.args.minimapbutton.args.border = ACH:Toggle(L['Border for Icons'], nil, 7, nil, false, nil, nil, nil, function() return not E.db.AYIJE.minimapbutton.enable end)
	ayijeoptions.Modules.args.minimapbutton.args.mouseover = ACH:Toggle(L['Mouse Over'], L['The frame is not shown unless you mouse over the frame.'], 7, nil, false, nil, nil, function(info, value) E.db.AYIJE.minimapbutton.mouseover = value; MB:ChangeMouseOverSetting() end, function() return not E.db.AYIJE.minimapbutton.enable or E.db.AYIJE.minimapbutton.skinstyle == 'NOANCHOR' end)
	
	ayijeoptions.Modules.args.minimapid = ACH:Group(L["Minimap Instance Difficulty"], nil, 4, nil, function(info) return E.db.AYIJE.minimapid [info[#info]] end, function(info, value) E.db.AYIJE.minimapid[info[#info]] = value E:StaticPopup_Show("AYIJE_RL") end, nil, nil, nil)
	ayijeoptions.Modules.args.minimapid.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.Modules.args.minimapid.args.desc.inline = true
	ayijeoptions.Modules.args.minimapid.args.desc.args.feature = ACH:Description(L["Add Instance Difficulty in text format."], 1, "medium")
	ayijeoptions.Modules.args.minimapid.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.Modules.args.minimapid.args.enable = ACH:Toggle(L["Enable"], nil, 3, nil, nil, nil, nil, nil, nil, nil)
	ayijeoptions.Modules.args.minimapid.args.align = ACH:Select(L["Text Align"], nil, 4, {LEFT = L["Left"], CENTER = L["Center"], RIGHT = L["Right"]}, nil, nil, nil, nil, nil, nil)
	ayijeoptions.Modules.args.minimapid.args.hideBlizzard = ACH:Toggle(L["Hide Blizzard Indicator"], nil, 5, nil, nil, nil, nil, nil, nil, nil)
	ayijeoptions.Modules.args.minimapid.args.font = ACH:Group(L["Font"], nil, 6, nil, function(info) return E.db.AYIJE.minimapid.font[info[#info]] end, function(info, value) E.db.AYIJE.minimapid.font[info[#info]] = value E:StaticPopup_Show("AYIJE_RL") end, nil, nil, nil)
	ayijeoptions.Modules.args.minimapid.args.font.inline = true
	ayijeoptions.Modules.args.minimapid.args.font.args.name = ACH:SharedMediaFont(L["Font"], nil, 1, nil, nil, nil, nil, nil, nil, nil)
	ayijeoptions.Modules.args.minimapid.args.font.args.style = ACH:Select(L["Outline"], nil, 2, {NONE = L["None"], OUTLINE = L["OUTLINE"], THICKOUTLINE = L["THICKOUTLINE"], SHADOW = L["SHADOW"], SHADOWOUTLINE = L["SHADOWOUTLINE"], SHADOWTHICKOUTLINE = L["SHADOWTHICKOUTLINE"], MONOCHROME = L["MONOCHROME"], MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"], MONOCHROMETHICKOUTLINE = L["MONOCHROMETHICKOUTLINE"]}, nil, nil, nil, nil, nil, nil)
	ayijeoptions.Modules.args.minimapid.args.font.args.size = ACH:Range(L["Size"], nil, 3, { min = 5, max = 60, step = 1 }, nil, nil, nil, nil, nil)

	ayijeoptions.Modules.args.cbackdrop = ACH:Group(L["Health Backdrop"], nil, 5)
	ayijeoptions.Modules.args.cbackdrop.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.Modules.args.cbackdrop.args.desc.inline = true
	ayijeoptions.Modules.args.cbackdrop.args.desc.args.feature = ACH:Description(L["Changes the health backdrop texture."], 1, "medium")
	ayijeoptions.Modules.args.cbackdrop.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.Modules.args.cbackdrop.args.custom = ACH:Toggle(L["Enable"], nil, 3, nil, false, nil,function() return E.db.AYIJE.cbackdrop.Backdrop end,function(_, value) E.db.AYIJE.cbackdrop.Backdrop = value E:StaticPopup_Show('AYIJE_RL'); AYIJE:CustomHealthBackdrop() end)
	ayijeoptions.Modules.args.cbackdrop.args.customtexture = ACH:SharedMediaStatusbar(L["Backdrop Texture"], L["Select a Texture"], 4, nil, function() return E.db.AYIJE.cbackdrop.customtexture end, function(_,key) E.db.AYIJE.cbackdrop.customtexture = key E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.cbackdrop.Backdrop end)

	-- Borders
	ayijeoptions.UnitFrames = ACH:Group(L["UnitFrames"], nil, 4, 'tab')
	ayijeoptions.UnitFrames.args.desc = ACH:Header(L["UnitFrames"], 1)
	ayijeoptions.UnitFrames.args.general = ACH:Group(L["General"], nil, 1, nil, nil, nil, nil, nil, nil)
	ayijeoptions.UnitFrames.args.general.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.general.args.desc.inline = true
	ayijeoptions.UnitFrames.args.general.args.desc.args.feature = ACH:Description(L["Adds new features to UnitFrames"], 1, "medium")
	ayijeoptions.UnitFrames.args.general.args.spacer = ACH:Header(L[""], 2)
	
	ayijeoptions.UnitFrames.args.general.args.glowline = ACH:Group(L["Health Glowline"], nil, 3)
	ayijeoptions.UnitFrames.args.general.args.glowline.inline = true
	ayijeoptions.UnitFrames.args.general.args.glowline.args.enable = ACH:Toggle(L["Health Glowline"], nil, 1, nil, false, "full", function() return E.db.AYIJE.unitframe.unitFramesGlowline end,function(_, value) E.db.AYIJE.unitframe.unitFramesGlowline = value E:StaticPopup_Show('AYIJE_RL') end)

	ayijeoptions.UnitFrames.args.general.args.portraits = ACH:Group(L["Portraits"], nil, 4)
	ayijeoptions.UnitFrames.args.general.args.portraits.inline = true
	ayijeoptions.UnitFrames.args.general.args.portraits.args.classPortraits = ACH:Toggle(L["Class Portrait"], L["Use Class Portraits instead of Unit Portraits"], 1, nil, false, "full", function() return E.db.AYIJE.unitframe.classPortraits end,function(_, value) E.db.AYIJE.unitframe.classPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.UnitFrames.args.general.args.portraits.args.framelevelPortraits = ACH:Range(L["Frame Level of Portrait"], L["Default: 1"], 6, { min = 1, max = 20, step = 1 }, "full", function() return E.db.AYIJE.unitframe.framelevelPortraits end, function(_, value) E.db.AYIJE.unitframe.framelevelPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.UnitFrames.args.general.args.portraits.args.playerpositionPortraits = ACH:Range(L["Offset of Player Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.playerpositionPortraits end, function(_, value) E.db.AYIJE.unitframe.playerpositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.UnitFrames.args.general.args.portraits.args.targetpositionPortraits = ACH:Range(L["Offset of Target Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.targetpositionPortraits end, function(_, value) E.db.AYIJE.unitframe.targetpositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.UnitFrames.args.general.args.portraits.args.focuspositionPortraits = ACH:Range(L["Offset of Focus Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.focuspositionPortraits end, function(_, value) E.db.AYIJE.unitframe.focuspositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.UnitFrames.args.general.args.portraits.args.targettargetpositionPortraits = ACH:Range(L["Offset of TargetTarget Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.targettargetpositionPortraits end, function(_, value) E.db.AYIJE.unitframe.targettargetpositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)

	ayijeoptions.UnitFrames.args.playerborder = ACH:Group(L["Player"], nil, 10, nil, nil, nil, function() return not E.db.unitframe.units.player.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.playerborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.playerborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.playerborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Player Unitframe"], 1, "medium")
	ayijeoptions.UnitFrames.args.playerborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.playerborder.args.player = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full", function() return E.db.AYIJE.border.Player end,function(_, value) E.db.AYIJE.border.Player = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.player.enable end)
	ayijeoptions.UnitFrames.args.playerborder.args.playerpor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.playerpor end,function(_, value) E.db.AYIJE.border.playerpor = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.player.enable or not E.db.AYIJE.border.Player end)
	ayijeoptions.UnitFrames.args.playerborder.args.playersep = ACH:Toggle(L["Power/Health Separator"], nil, 4, nil, false, "full", function() return E.db.AYIJE.border.Playersep end,function(_, value) E.db.AYIJE.border.Playersep = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.player.power.enable or not E.db.AYIJE.border.Player or not E.db.unitframe.units.player.enable end)

	ayijeoptions.UnitFrames.args.petborder = ACH:Group(L["Pet"], nil, 11, nil, nil, nil, function() return not E.db.unitframe.units.pet.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.petborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.petborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.petborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Pet Unitframe"], 1, "medium")
	ayijeoptions.UnitFrames.args.petborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.petborder.args.pet = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Pet end,function(_, value) E.db.AYIJE.border.Pet = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.pet.enable end)
	
	ayijeoptions.UnitFrames.args.pettargetborder = ACH:Group(L["Pet Target"], nil, 12, nil, nil, nil, function() return not E.db.unitframe.units.pettarget.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.pettargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.pettargetborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.pettargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Pet Target Unitframe"], 1, "medium")
	ayijeoptions.UnitFrames.args.pettargetborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.pettargetborder.args.enable = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.PetTarget end,function(_, value) E.db.AYIJE.border.PetTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.pettarget.enable end)
	
	ayijeoptions.UnitFrames.args.targetborder = ACH:Group(L["Target"], nil, 30, nil, nil, nil, function() return not E.db.unitframe.units.target.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.targetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.targetborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.targetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Target Unitframes."], 1, "medium")
	ayijeoptions.UnitFrames.args.targetborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.targetborder.args.target = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Target end,function(_, value) E.db.AYIJE.border.Target = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.target.enable end)
	ayijeoptions.UnitFrames.args.targetborder.args.targetsep = ACH:Toggle(L["Power/Health Separator"], nil, 4, nil, false, "full",function() return E.db.AYIJE.border.Targetsep end,function(_, value) E.db.AYIJE.border.Targetsep = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.target.power.enable or not E.db.AYIJE.border.Target end)
	ayijeoptions.UnitFrames.args.targetborder.args.targetpor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.targetpor end,function(_, value) E.db.AYIJE.border.targetpor = value E:StaticPopup_Show('AYIJE_RL')  end, function() return not E.db.unitframe.units.target.enable or not E.db.AYIJE.border.Target end)

	ayijeoptions.UnitFrames.args.focusborder = ACH:Group(L["Focus"], nil, 40, nil, nil, nil, function() return not E.db.unitframe.units.focus.enable end, not E.Retail, nil)
	ayijeoptions.UnitFrames.args.focusborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.focusborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.focusborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Focus Unitframes."], 1, "medium")
	ayijeoptions.UnitFrames.args.focusborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.focusborder.args.focus = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Focus end,function(_, value) E.db.AYIJE.border.Focus = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.focus.enable end)
	ayijeoptions.UnitFrames.args.focusborder.args.focuspor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.focuspor end,function(_, value) E.db.AYIJE.border.focuspor = value E:StaticPopup_Show('AYIJE_RL')  end, function() return not E.db.unitframe.units.focus.enable or not E.db.AYIJE.border.Focus end)
	
	ayijeoptions.UnitFrames.args.focustargetborder = ACH:Group(L["Focus Target"], nil, 41, nil, nil, nil, function() return not E.db.unitframe.units.focustarget.enable end, not E.Retail, nil)
	ayijeoptions.UnitFrames.args.focustargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.focustargetborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.focustargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Focus Target Unitframes."], 1, "medium")
	ayijeoptions.UnitFrames.args.focustargetborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.focustargetborder.args.enable = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.FocusTarget end,function(_, value) E.db.AYIJE.border.FocusTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.focustarget.enable end)
	
	ayijeoptions.UnitFrames.args.targetoftargetborder = ACH:Group(L["Target of Target"], nil, 50, nil, nil, nil, function() return not E.db.unitframe.units.targettarget.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.targetoftargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.targetoftargetborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.targetoftargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Target of Target Unitframes"], 1, "medium")
	ayijeoptions.UnitFrames.args.targetoftargetborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.targetoftargetborder.args.tot = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.TargetofTarget end,function(_, value) E.db.AYIJE.border.TargetofTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.targettarget.enable end)
	ayijeoptions.UnitFrames.args.targetoftargetborder.args.targettargetpor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.targettargetpor end,function(_, value) E.db.AYIJE.border.targettargetpor = value E:StaticPopup_Show('AYIJE_RL')  end, function() return not E.db.unitframe.units.targettarget.enable or not E.db.AYIJE.border.TargetofTarget end)
	
	ayijeoptions.UnitFrames.args.targetoftargetoftargetborder = ACH:Group(L["Target of Target of Target"], nil, 51, nil, nil, nil, function() return not E.db.unitframe.units.targettargettarget.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.targetoftargetoftargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.targetoftargetoftargetborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.targetoftargetoftargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Target of Target Unitframes"], 1, "medium")
	ayijeoptions.UnitFrames.args.targetoftargetoftargetborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.targetoftargetoftargetborder.args.enable = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.TargetofTargetofTarget end,function(_, value) E.db.AYIJE.border.TargetofTargetofTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.targettargettarget.enable end)
	
	ayijeoptions.UnitFrames.args.partyborder = ACH:Group(L["Party"], nil, 60, nil, nil, nil, function() return not E.db.unitframe.units.party.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.partyborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.partyborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.partyborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Party Unitframe."], 1, "medium")
	ayijeoptions.UnitFrames.args.partyborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.partyborder.args.party = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Party end,function(_, value) E.db.AYIJE.border.Party = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.party.enable end)
	ayijeoptions.UnitFrames.args.partyborder.args.PartySpaced = ACH:Toggle(L["Party Spaced"], nil, 4, nil, false, "full",function() return E.db.AYIJE.border.PartySpaced end,function(_, value) E.db.AYIJE.border.PartySpaced = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.party.enable end)
	ayijeoptions.UnitFrames.args.partyborder.args.partysep = ACH:Toggle(L["Separator"], nil, 5, nil, false, "full",function() return E.db.AYIJE.border.Partysep end,function(_, value) E.db.AYIJE.border.Partysep = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.party.enable or not E.db.AYIJE.border.Party end)
	
	ayijeoptions.UnitFrames.args.raidborder = ACH:Group(L["Raid"], nil, 70, nil, nil, nil, function() return not E.db.unitframe.units.raid1.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.raidborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.raidborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.raidborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Raid Unitframe."], 1, "medium")
	ayijeoptions.UnitFrames.args.raidborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.raidborder.args.raid = ACH:Toggle(L["Heal"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.raid end,function(_, value) E.db.AYIJE.border.raid = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.raid1.enable end)
	ayijeoptions.UnitFrames.args.raidborder.args.raidbackdrop = ACH:Toggle(L["Heal (Backdrop)"], nil, 4, nil, false, "full",function() return E.db.AYIJE.border.raidbackdrop end,function(_, value) E.db.AYIJE.border.raidbackdrop = value E:StaticPopup_Show('AYIJE_RL') end, nil, function() return not E.db.AYIJE.border.raid end)
	ayijeoptions.UnitFrames.args.raidborder.args.raiddps = ACH:Toggle(L["DPS/TANK"], nil, 5, nil, false, "full",function() return E.db.AYIJE.border.raiddps end,function(_, value) E.db.AYIJE.border.raiddps = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.raid1.enable end)
	
	ayijeoptions.UnitFrames.args.tankframeborder = ACH:Group(L["Tank Frames"], nil, 70, nil, nil, nil, function() return not E.db.unitframe.units.tank.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.tankframeborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.tankframeborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.tankframeborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Tank Unitframe."], 1, "medium")
	ayijeoptions.UnitFrames.args.tankframeborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.tankframeborder.args.maintankofftank = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Maintankofftank end,function(_, value) E.db.AYIJE.border.Maintankofftank = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.tank.enable end)
	ayijeoptions.UnitFrames.args.assistunitborder= ACH:Group(L["Assist Units"], nil, 70, nil, nil, nil, function() return not E.db.unitframe.units.assist.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.assistunitborder.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.assistunitborder.args.desc.inline = true
	ayijeoptions.UnitFrames.args.assistunitborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Assist Unitframe."], 1, "medium")
	ayijeoptions.UnitFrames.args.assistunitborder.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.assistunitborder.args.maintankofftank = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.AssistUnits end,function(_, value) E.db.AYIJE.border.AssistUnits = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.assist.enable end)
	
	ayijeoptions.UnitFrames.args.bossborders = ACH:Group(L["Boss"], nil, 80, nil, nil, nil, function() return not E.db.unitframe.units.boss.enable end, not E.Retail, nil)
	ayijeoptions.UnitFrames.args.bossborders.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.bossborders.args.desc.inline = true
	ayijeoptions.UnitFrames.args.bossborders.args.desc.args.feature = ACH:Description(L["Adds a border to the Boss Unitframes"], 1, "medium")
	ayijeoptions.UnitFrames.args.bossborders.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.bossborders.args.boss = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Boss end,function(_, value) E.db.AYIJE.border.Boss = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.boss.enable end)

	ayijeoptions.UnitFrames.args.arenaborders = ACH:Group(L["Arena"], nil, 90, nil, nil, nil, function() return not E.db.unitframe.units.arena.enable end, not E.Retail, nil)
	ayijeoptions.UnitFrames.args.arenaborders.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.arenaborders.args.desc.inline = true
	ayijeoptions.UnitFrames.args.arenaborders.args.desc.args.feature = ACH:Description(L["Adds a border to the Arena Unitframes"], 1, "medium")
	ayijeoptions.UnitFrames.args.arenaborders.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.arenaborders.args.arena = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Arena end,function(_, value) E.db.AYIJE.border.Arena = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.arena.enable end)
	
	ayijeoptions.UnitFrames.args.auraborder = ACH:Group(L["Buffs/Debuffs"], nil, 100, 'tab')
	ayijeoptions.UnitFrames.args.auraborder.args.minimap = ACH:Group(L["Minimap"], nil, 1, nil, nil, nil, function() return not E.private.auras.enable end, nil, nil)
	ayijeoptions.UnitFrames.args.auraborder.args.minimap.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.auraborder.args.minimap.args.desc.inline = true
	ayijeoptions.UnitFrames.args.auraborder.args.minimap.args.desc.args.feature = ACH:Description(L["Adds a border to the Buffs and Debuffs at Minimap."], 2, "medium")
	ayijeoptions.UnitFrames.args.auraborder.args.minimap.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.UnitFrames.args.auraborder.args.minimap.args.aura = ACH:Toggle(L["Enable"], L["Toggle the border of Buffs and Debuffs at minimap."], 3, nil, false, "full",function() return E.db.AYIJE.border.Aura end,function(_, value) E.db.AYIJE.border.Aura = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.private.auras.enable end)
	ayijeoptions.UnitFrames.args.auraborder.args.unitframes = ACH:Group(L["Unitframes"], nil, 1)
	ayijeoptions.UnitFrames.args.auraborder.args.unitframes.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.UnitFrames.args.auraborder.args.unitframes.args.desc.inline = true
	ayijeoptions.UnitFrames.args.auraborder.args.unitframes.args.desc.args.feature = ACH:Description(L["Adds a border to the Buffs and Debuffs on Unitframes."], 2, "medium")
	ayijeoptions.UnitFrames.args.auraborder.args.unitframes.args.spacer = ACH:Header(L[""], 7)
	ayijeoptions.UnitFrames.args.auraborder.args.unitframes.args.uf = ACH:Toggle(L["Enable"], L["Toggle the border of Buffs and Debuffs at Unitframes."], 8, nil, false, "full",function() return E.db.AYIJE.border.AuraUF end,function(_, value) E.db.AYIJE.border.AuraUF = value E:StaticPopup_Show('AYIJE_RL') end, nil)

	ayijeoptions.Skins = ACH:Group(L["Skins"], nil, 5, 'tab')

	local addonskins = {
		"warpdeplete",
		"bigwigsqueue",
		"omnicd",
		"weakAurasOptions",
		"details",
		"detailsresize",
		"grid2",
	}
	ayijeoptions.Skins.args.desc = ACH:Header(L["Skins"], 1)
	ayijeoptions.Skins.args.AddOns = ACH:Group(L["AddOns"], nil, 1)
	ayijeoptions.Skins.args.AddOns.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.Skins.args.AddOns.args.desc.inline = true
	ayijeoptions.Skins.args.AddOns.args.desc.args.feature = ACH:Description(L["Skins Addons to fit AyijeUI."], 1, "medium")
	ayijeoptions.Skins.args.AddOns.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.Skins.args.AddOns.args.buttonGroup = ACH:Group(L[""], nil, 3)
	ayijeoptions.Skins.args.AddOns.args.buttonGroup.inline = true
	ayijeoptions.Skins.args.AddOns.args.buttonGroup.args.enableAll = ACH:Execute(L["Enable All"], nil, 1, function() for _, skin in ipairs(addonskins) do E.db.AYIJE.skins[skin] = true end E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.AddOns.args.buttonGroup.args.disableAll = ACH:Execute(L["Disable All"], nil, 2, function() for _, skin in ipairs(addonskins) do E.db.AYIJE.skins[skin] = false end E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.AddOns.args.warpDeplete = ACH:Toggle(L["WarpDeplete"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.warpdeplete end,function(_, value) E.db.AYIJE.skins.warpdeplete = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("WarpDeplete") end)
	ayijeoptions.Skins.args.AddOns.args.bigwigsqueue = ACH:Toggle(L["BigWigs Queue"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.bigwigsqueue end,function(_, value) E.db.AYIJE.skins.bigwigsqueue = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("BigWigs") end)
	ayijeoptions.Skins.args.AddOns.args.omnicd = ACH:Toggle(L["OmniCD"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.omnicd end,function(_, value) E.db.AYIJE.skins.omnicd = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("OmniCD") end)
	ayijeoptions.Skins.args.AddOns.args.weakAurasOptions = ACH:Toggle(L["Weakauras Option"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.weakAurasOptions end,function(_, value) E.db.AYIJE.skins.weakAurasOptions = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("Weakauras") end)
	ayijeoptions.Skins.args.AddOns.args.details = ACH:Toggle(L["Details"], L["Adds a border, background and separators to Details\n\n|cFFFF0000This will only work 100% with AYIJE Details Profile.|r"], 3, nil, false, nil, function() return E.db.AYIJE.skins.details end,function(_, value) E.db.AYIJE.skins.details = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("Details") end)
	ayijeoptions.Skins.args.AddOns.args.detailsResize = ACH:Toggle(L["Details AutoResizer"], L["Resize Details Window 2 based on Zone type.\n   - Shows 2 players for none/party zone.\n   - Shows 5 players in raid zone."], 3, nil, false, nil, function() return E.db.AYIJE.skins.detailsresize end,function(_, value) E.db.AYIJE.skins.detailsresize = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.AYIJE.skins.details end, function() return not E.db.AYIJE.skins.details end)
	ayijeoptions.Skins.args.AddOns.args.grid2 = ACH:Toggle(L["Grid2"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.grid2 end,function(_, value) E.db.AYIJE.skins.grid2 = value E:StaticPopup_Show('AYIJE_RL') end, function() return not IsAddOnLoaded("Grid2") end)

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
	}

	ayijeoptions.Skins.args.Elvui = ACH:Group(L["ElvUI"], nil, 1)
	ayijeoptions.Skins.args.Elvui.args.desc = ACH:Group(L["Description"], nil, 1)
	ayijeoptions.Skins.args.Elvui.args.desc.inline = true
	ayijeoptions.Skins.args.Elvui.args.desc.args.feature = ACH:Description(L["Skins ElvUi frames to fit AyijeUI."], 1, "medium")
	ayijeoptions.Skins.args.Elvui.args.spacer = ACH:Header(L[""], 2)
	ayijeoptions.Skins.args.Elvui.args.buttonGroup = ACH:Group(L[""], nil, 3)
	ayijeoptions.Skins.args.Elvui.args.buttonGroup.inline = true
	ayijeoptions.Skins.args.Elvui.args.buttonGroup.args.enableAll = ACH:Execute(L["Enable All"], nil, 1, function() for _, skin in ipairs(elvuiskins) do E.db.AYIJE.skins[skin] = true end E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.buttonGroup.args.disableAll = ACH:Execute(L["Disable All"], nil, 2, function() for _, skin in ipairs(elvuiskins) do E.db.AYIJE.skins[skin] = false end E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.actionBarsBackdrop = ACH:Toggle(L["Actionbars Backdrop"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.actionBarsBackdrop end,function(_, value) E.db.AYIJE.skins.actionBarsBackdrop = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.actionBarsButton = ACH:Toggle(L["Actionbars Button"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.actionBarsButton end,function(_, value) E.db.AYIJE.skins.actionBarsButton = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.afk = ACH:Toggle(L["AFK Mode"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.afk end,function(_, value) E.db.AYIJE.skins.afk = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.altPowerBar = ACH:Toggle(L["Alt Power"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.altPowerBar end,function(_, value) E.db.AYIJE.skins.altPowerBar = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.chatDataPanels = ACH:Toggle(L["Chat Data Panels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatDataPanels end,function(_, value) E.db.AYIJE.skins.chatDataPanels = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.chatPanels = ACH:Toggle(L["Chat Panels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatPanels end,function(_, value) E.db.AYIJE.skins.chatPanels = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.chatVoicePanel = ACH:Toggle(L["Chat Voice Panel"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatVoicePanel end,function(_, value) E.db.AYIJE.skins.chatVoicePanel = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.chatCopyFrame = ACH:Toggle(L["Chat Copy Frame"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.chatCopyFrame end,function(_, value) E.db.AYIJE.skins.chatCopyFrame = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.lootRoll = ACH:Toggle(L["Loot Roll"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.lootRoll end,function(_, value) E.db.AYIJE.skins.lootRoll = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.options = ACH:Toggle(L["Options"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.options end,function(_, value) E.db.AYIJE.skins.options = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.panels = ACH:Toggle(L["Panels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.panels end,function(_, value) E.db.AYIJE.skins.panels = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.raidUtility = ACH:Toggle(L["Raid Utility"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.raidUtility end,function(_, value) E.db.AYIJE.skins.raidUtility = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.staticPopup = ACH:Toggle(L["Static Popup"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.staticPopup end,function(_, value) E.db.AYIJE.skins.staticPopup = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.statusReport = ACH:Toggle(L["Status Report"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.statusReport end,function(_, value) E.db.AYIJE.skins.statusReport = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.totemTracker = ACH:Toggle(L["Totem Tracker"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.totemTracker end,function(_, value) E.db.AYIJE.skins.totemTracker = value E:StaticPopup_Show('AYIJE_RL') end)
	ayijeoptions.Skins.args.Elvui.args.minimap = ACH:Toggle(L["MiniMap"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.Minimap end,function(_, value) E.db.AYIJE.skins.Minimap = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.private.general.minimap.enable end)
	ayijeoptions.Skins.args.Elvui.args.dataPanels = ACH:Toggle(L["DataPanels"], nil, 3, nil, false, nil, function() return E.db.AYIJE.skins.dataPanels end,function(_, value) E.db.AYIJE.skins.dataPanels = value E:StaticPopup_Show('AYIJE_RL') end)

	E.Options.args.AYIJE = AYIJE.Options

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
end
--[[
	ACH:Color(name, desc, order, alpha, width, get, set, disabled, hidden)
	ACH:Description(name, order, fontSize, image, imageCoords, imageWidth, imageHeight, width, hidden)
	ACH:Execute(name, desc, order, func, image, confirm, width, get, set, disabled, hidden)
	ACH:Group(name, desc, order, childGroups, get, set, disabled, hidden, func)
	ACH:Header(name, order, get, set, hidden)
	ACH:Input(name, desc, order, multiline, width, get, set, disabled, hidden, validate)
	ACH:MultiSelect(name, desc, order, values, confirm, width, get, set, disabled, hidden)
	ACH:Range(name, desc, order, values, width, get, set, disabled, hidden)
	ACH:Select(name, desc, order, values, confirm, width, get, set, disabled, hidden)
	ACH:Spacer(order, width, hidden)
	ACH:Toggle(name, desc, order, tristate, confirm, width, get, set, disabled, hidden)
]]
