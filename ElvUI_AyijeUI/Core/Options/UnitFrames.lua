local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local ACH = E.Libs.ACH

function AYIJE:UnitFrames()
  local AOA = AYIJE.Options.args

	AOA.UnitFrames = ACH:Group(L["UnitFrames"], nil, 10, 'tab')

	local AOAUF = AOA.UnitFrames.args

	AOAUF.desc = ACH:Header(L["UnitFrames"], 1)
	AOAUF.general = ACH:Group(L["General"], nil, 1, nil, nil, nil, nil, nil, nil)
	AOAUF.general.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.general.args.desc.inline = true
	AOAUF.general.args.desc.args.feature = ACH:Description(L["Adds new features to UnitFrames"], 1, "medium")
	AOAUF.general.args.spacer = ACH:Header(L[""], 2)
	
	AOAUF.general.args.overshield = ACH:Group(L["Overshield"], nil, 3)
	AOAUF.general.args.overshield.inline = true
	AOAUF.general.args.overshield.args.enable = ACH:Toggle(L["Overshield"], nil, 1, nil, false, "full", function() return E.db.AYIJE.unitframe.overshield end,function(_, value) E.db.AYIJE.unitframe.overshield = value E:StaticPopup_Show('AYIJE_RL') end)

	AOAUF.general.args.glowline = ACH:Group(L["Health Glowline"], nil, 3)
	AOAUF.general.args.glowline.inline = true
	AOAUF.general.args.glowline.args.enable = ACH:Toggle(L["Health Glowline"], nil, 1, nil, false, "full", function() return E.db.AYIJE.unitframe.unitFramesGlowline end,function(_, value) E.db.AYIJE.unitframe.unitFramesGlowline = value E:StaticPopup_Show('AYIJE_RL') end)

	AOAUF.general.args.customtargetborder = ACH:Group(L["Target Border"], nil, 3)
	AOAUF.general.args.customtargetborder.inline = true
	AOAUF.general.args.customtargetborder.args.enable = ACH:Toggle(L["Enable"], L['Toggle the Target Border frame. (Target Frame Glow MUST be enabled.)'], 2, nil, false, nil, function() return E.db.AYIJE.targetGlow end,function(_, value) E.db.AYIJE.targetGlow = value E:StaticPopup_Show('AYIJE_RL') end)
	
	AOAUF.general.args.portraits = ACH:Group(L["Portraits"], nil, 4)
	AOAUF.general.args.portraits.inline = true
	AOAUF.general.args.portraits.args.classPortraits = ACH:Toggle(L["Class Portrait"], L["Use Class Portraits instead of Unit Portraits"], 1, nil, false, "full", function() return E.db.AYIJE.unitframe.classPortraits end,function(_, value) E.db.AYIJE.unitframe.classPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	AOAUF.general.args.portraits.args.framelevelPortraits = ACH:Range(L["Frame Level of Portrait"], L["Default: 1"], 6, { min = 1, max = 20, step = 1 }, "full", function() return E.db.AYIJE.unitframe.framelevelPortraits end, function(_, value) E.db.AYIJE.unitframe.framelevelPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	AOAUF.general.args.portraits.args.playerpositionPortraits = ACH:Range(L["Offset of Player Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.playerpositionPortraits end, function(_, value) E.db.AYIJE.unitframe.playerpositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	AOAUF.general.args.portraits.args.targetpositionPortraits = ACH:Range(L["Offset of Target Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.targetpositionPortraits end, function(_, value) E.db.AYIJE.unitframe.targetpositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	AOAUF.general.args.portraits.args.focuspositionPortraits = ACH:Range(L["Offset of Focus Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.focuspositionPortraits end, function(_, value) E.db.AYIJE.unitframe.focuspositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)
	AOAUF.general.args.portraits.args.targettargetpositionPortraits = ACH:Range(L["Offset of TargetTarget Portait"], nil, 6, { min = -100, max = 100, step = 1 }, "full", function() return E.db.AYIJE.unitframe.targettargetpositionPortraits end, function(_, value) E.db.AYIJE.unitframe.targettargetpositionPortraits = value E:StaticPopup_Show('AYIJE_RL') end)

	AOAUF.playerborder = ACH:Group(L["Player"], nil, 10, nil, nil, nil, function() return not E.db.unitframe.units.player.enable end, nil, nil)
	AOAUF.playerborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.playerborder.args.desc.inline = true
	AOAUF.playerborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Player Unitframe"], 1, "medium")
	AOAUF.playerborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.playerborder.args.player = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full", function() return E.db.AYIJE.border.Player end,function(_, value) E.db.AYIJE.border.Player = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.player.enable end)
	AOAUF.playerborder.args.playerpor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.playerpor end,function(_, value) E.db.AYIJE.border.playerpor = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.player.enable or not E.db.AYIJE.border.Player end)
	AOAUF.playerborder.args.playersep = ACH:Toggle(L["Power/Health Separator"], nil, 4, nil, false, "full", function() return E.db.AYIJE.border.Playersep end,function(_, value) E.db.AYIJE.border.Playersep = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.player.power.enable or not E.db.AYIJE.border.Player or not E.db.unitframe.units.player.enable end)

	AOAUF.petborder = ACH:Group(L["Pet"], nil, 11, nil, nil, nil, function() return not E.db.unitframe.units.pet.enable end, nil, nil)
	AOAUF.petborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.petborder.args.desc.inline = true
	AOAUF.petborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Pet Unitframe"], 1, "medium")
	AOAUF.petborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.petborder.args.pet = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Pet end,function(_, value) E.db.AYIJE.border.Pet = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.pet.enable end)
	
	AOAUF.pettargetborder = ACH:Group(L["Pet Target"], nil, 12, nil, nil, nil, function() return not E.db.unitframe.units.pettarget.enable end, nil, nil)
	AOAUF.pettargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.pettargetborder.args.desc.inline = true
	AOAUF.pettargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Pet Target Unitframe"], 1, "medium")
	AOAUF.pettargetborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.pettargetborder.args.enable = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.PetTarget end,function(_, value) E.db.AYIJE.border.PetTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.pettarget.enable end)
	
	AOAUF.targetborder = ACH:Group(L["Target"], nil, 30, nil, nil, nil, function() return not E.db.unitframe.units.target.enable end, nil, nil)
	AOAUF.targetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.targetborder.args.desc.inline = true
	AOAUF.targetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Target Unitframes."], 1, "medium")
	AOAUF.targetborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.targetborder.args.target = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Target end,function(_, value) E.db.AYIJE.border.Target = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.target.enable end)
	AOAUF.targetborder.args.targetsep = ACH:Toggle(L["Power/Health Separator"], nil, 4, nil, false, "full",function() return E.db.AYIJE.border.Targetsep end,function(_, value) E.db.AYIJE.border.Targetsep = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.target.power.enable or not E.db.AYIJE.border.Target end)
	AOAUF.targetborder.args.targetpor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.targetpor end,function(_, value) E.db.AYIJE.border.targetpor = value E:StaticPopup_Show('AYIJE_RL')  end, function() return not E.db.unitframe.units.target.enable or not E.db.AYIJE.border.Target end)

	AOAUF.focusborder = ACH:Group(L["Focus"], nil, 40, nil, nil, nil, function() return not E.db.unitframe.units.focus.enable end, not E.Retail, nil)
	AOAUF.focusborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.focusborder.args.desc.inline = true
	AOAUF.focusborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Focus Unitframes."], 1, "medium")
	AOAUF.focusborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.focusborder.args.focus = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Focus end,function(_, value) E.db.AYIJE.border.Focus = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.focus.enable end)
	AOAUF.focusborder.args.focuspor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.focuspor end,function(_, value) E.db.AYIJE.border.focuspor = value E:StaticPopup_Show('AYIJE_RL')  end, function() return not E.db.unitframe.units.focus.enable or not E.db.AYIJE.border.Focus end)
	
	AOAUF.focustargetborder = ACH:Group(L["Focus Target"], nil, 41, nil, nil, nil, function() return not E.db.unitframe.units.focustarget.enable end, not E.Retail, nil)
	AOAUF.focustargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.focustargetborder.args.desc.inline = true
	AOAUF.focustargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Focus Target Unitframes."], 1, "medium")
	AOAUF.focustargetborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.focustargetborder.args.enable = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.FocusTarget end,function(_, value) E.db.AYIJE.border.FocusTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.focustarget.enable end)
	
	AOAUF.targetoftargetborder = ACH:Group(L["Target of Target"], nil, 50, nil, nil, nil, function() return not E.db.unitframe.units.targettarget.enable end, nil, nil)
	AOAUF.targetoftargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.targetoftargetborder.args.desc.inline = true
	AOAUF.targetoftargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Target of Target Unitframes"], 1, "medium")
	AOAUF.targetoftargetborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.targetoftargetborder.args.tot = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.TargetofTarget end,function(_, value) E.db.AYIJE.border.TargetofTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.targettarget.enable end)
	AOAUF.targetoftargetborder.args.targettargetpor = ACH:Toggle(L["Portrait"], nil, 5, nil, false, "full", function() return E.db.AYIJE.border.targettargetpor end,function(_, value) E.db.AYIJE.border.targettargetpor = value E:StaticPopup_Show('AYIJE_RL')  end, function() return not E.db.unitframe.units.targettarget.enable or not E.db.AYIJE.border.TargetofTarget end)
	
	AOAUF.targetoftargetoftargetborder = ACH:Group(L["Target of Target of Target"], nil, 51, nil, nil, nil, function() return not E.db.unitframe.units.targettargettarget.enable end, nil, nil)
	AOAUF.targetoftargetoftargetborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.targetoftargetoftargetborder.args.desc.inline = true
	AOAUF.targetoftargetoftargetborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Target of Target Unitframes"], 1, "medium")
	AOAUF.targetoftargetoftargetborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.targetoftargetoftargetborder.args.enable = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.TargetofTargetofTarget end,function(_, value) E.db.AYIJE.border.TargetofTargetofTarget = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.targettargettarget.enable end)
	
	AOAUF.tankframeborder = ACH:Group(L["Tank Frames"], nil, 70, nil, nil, nil, function() return not E.db.unitframe.units.tank.enable end, nil, nil)
	AOAUF.tankframeborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.tankframeborder.args.desc.inline = true
	AOAUF.tankframeborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Tank Unitframe."], 1, "medium")
	AOAUF.tankframeborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.tankframeborder.args.maintankofftank = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Maintankofftank end,function(_, value) E.db.AYIJE.border.Maintankofftank = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.tank.enable end)
	AOAUF.assistunitborder= ACH:Group(L["Assist Units"], nil, 70, nil, nil, nil, function() return not E.db.unitframe.units.assist.enable end, nil, nil)
	AOAUF.assistunitborder.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.assistunitborder.args.desc.inline = true
	AOAUF.assistunitborder.args.desc.args.feature = ACH:Description(L["Adds a border to the Assist Unitframe."], 1, "medium")
	AOAUF.assistunitborder.args.spacer = ACH:Header(L[""], 2)
	AOAUF.assistunitborder.args.maintankofftank = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.AssistUnits end,function(_, value) E.db.AYIJE.border.AssistUnits = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.assist.enable end)
	
	AOAUF.bossborders = ACH:Group(L["Boss"], nil, 80, nil, nil, nil, function() return not E.db.unitframe.units.boss.enable end, not E.Retail, nil)
	AOAUF.bossborders.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.bossborders.args.desc.inline = true
	AOAUF.bossborders.args.desc.args.feature = ACH:Description(L["Adds a border to the Boss Unitframes"], 1, "medium")
	AOAUF.bossborders.args.spacer = ACH:Header(L[""], 2)
	AOAUF.bossborders.args.boss = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Boss end,function(_, value) E.db.AYIJE.border.Boss = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.boss.enable end)

	AOAUF.arenaborders = ACH:Group(L["Arena"], nil, 90, nil, nil, nil, function() return not E.db.unitframe.units.arena.enable end, not E.Retail, nil)
	AOAUF.arenaborders.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.arenaborders.args.desc.inline = true
	AOAUF.arenaborders.args.desc.args.feature = ACH:Description(L["Adds a border to the Arena Unitframes"], 1, "medium")
	AOAUF.arenaborders.args.spacer = ACH:Header(L[""], 2)
	AOAUF.arenaborders.args.arena = ACH:Toggle(L["Enable"], nil, 3, nil, false, "full",function() return E.db.AYIJE.border.Arena end,function(_, value) E.db.AYIJE.border.Arena = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.db.unitframe.units.arena.enable end)
	
	AOAUF.auraborder = ACH:Group(L["Buffs/Debuffs"], nil, 100, 'tab')
	AOAUF.auraborder.args.minimap = ACH:Group(L["Minimap"], nil, 1, nil, nil, nil, function() return not E.private.auras.enable end, nil, nil)
	AOAUF.auraborder.args.minimap.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.auraborder.args.minimap.args.desc.inline = true
	AOAUF.auraborder.args.minimap.args.desc.args.feature = ACH:Description(L["Adds a border to the Buffs and Debuffs at Minimap."], 2, "medium")
	AOAUF.auraborder.args.minimap.args.spacer = ACH:Header(L[""], 2)
	AOAUF.auraborder.args.minimap.args.aura = ACH:Toggle(L["Enable"], L["Toggle the border of Buffs and Debuffs at minimap."], 3, nil, false, "full",function() return E.db.AYIJE.border.Aura end,function(_, value) E.db.AYIJE.border.Aura = value E:StaticPopup_Show('AYIJE_RL') end, function() return not E.private.auras.enable end)
	AOAUF.auraborder.args.unitframes = ACH:Group(L["Unitframes"], nil, 1)
	AOAUF.auraborder.args.unitframes.args.desc = ACH:Group(L["Description"], nil, 1)
	AOAUF.auraborder.args.unitframes.args.desc.inline = true
	AOAUF.auraborder.args.unitframes.args.desc.args.feature = ACH:Description(L["Adds a border to the Buffs and Debuffs on Unitframes."], 2, "medium")
	AOAUF.auraborder.args.unitframes.args.spacer = ACH:Header(L[""], 7)
	AOAUF.auraborder.args.unitframes.args.uf = ACH:Toggle(L["Enable"], L["Toggle the border of Buffs and Debuffs at Unitframes."], 8, nil, false, "full",function() return E.db.AYIJE.border.AuraUF end,function(_, value) E.db.AYIJE.border.AuraUF = value E:StaticPopup_Show('AYIJE_RL') end, nil)

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
