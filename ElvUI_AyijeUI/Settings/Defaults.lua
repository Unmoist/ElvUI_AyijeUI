local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local MiniMapButtonSelect = {NOANCHOR = 'No Anchor Bar', HORIZONTAL = 'Horizontal', VERTICAL = 'Vertical'}
local MiniMapButtonDirection = {NORMAL = 'Normal', REVERSED = 'Reversed'}
local norm = format("|cff1eff00%s|r", L["[ABBR] Normal"])
local hero = format("|cff0070dd%s|r", L["[ABBR] Heroic"])
local myth = format("|cffa335ee%s|r", L["[ABBR] Mythic"])
local lfr = format("|cffff8000%s|r", L["[ABBR] Looking for raid"])

-- Defaults: E.global.AYIJE
G.AYIJE = {
	dev = false,
	install_version = nil,
}

-- Defaults: E.private.AYIJE
V.AYIJE = {
}

-- Defaults: E.db.AYIJE
P.AYIJE = {
	targetGlow = false,
	manaFrame = {
		enable = false, 
		glowline = false,
		width = 146,
		height = 32,
		textsize = 18
	}, 

	-- UnitFrame Generals
	unitframe = {
		overshield = false,
		unitFramesGlowline = false,
		framelevelPortraits = 20,
		classPortraits = false, 
		playerpositionPortraits = -20,
		targetpositionPortraits = 20,
		focuspositionPortraits = 20,
		targettargetpositionPortraits = 20.
	},
	-- Rectangle Minimap
	minimap = {
		Rectangle = true,
	},
	-- Minimap Buttons
	minimapbutton = {
		enable = true,
		skinStyle = "HORIZONTAL",
		buttonSize = 40,
		backdrop = false,
		layoutDirection = "NORMAL",
		border = true,
		buttonsPerRow = 4,
		mouseover = false,
	},
	-- Minimap Instance Difficulty
	["minimapid"] = {
		["enable"] = true,
		["hideBlizzard"] = true,
		["align"] = "LEFT",
		["font"] = {
			["size"] = 20,
			},
	},
	-- Custom Health Backdrop
	cbackdrop = {
		Backdrop = true,
		customtexture = 'Ayije_dark',
	},
	-- border
	border = {
		-- Player
		Player = true,
		Playersep = true,
		playerpor = true,
		playerporframelevel = 25,
		-- Raid
		raid = true,
		raiddps = true,
		-- Pet
		Pet = true,
		Petsep = true,
		-- Pet target
		PetTarget = true,
		-- Target
		Target = true,
		Targetsep = true,
		targetpor = true,
		-- Focus
		Focus = true,
		Focussep = true,
		focuspor = true,
		-- Focus Target
		FocusTarget = true,
		-- Target Target
		TargetofTarget = true,
		TargetofTargetsep = true,
		targettargetpor = true,
		-- Target of Target of Target
		TargetofTargetofTarget = true,
		-- Party
		Party = true,
		Partysep = true,
		PartySpaced = true,
		-- Offtank and Main Tank
		maintankofftank = true,
		-- Assist Units
		AssistUnits = true,
		-- Boss
		Boss = true,
		Bosssep = true,
		-- Arena
		Arena = true,
		Arenasep = true,
		-- Buffs/Debuffs
		Aura = true, 
		AuraUF = true, 
		-- Minimap
		-- Bag
		Bag = true,
		Bagslot = true,
		-- OmniCD
		OmniCD = true,
	},
	skins = {
		-- Addons
		warpdeplete = true,
		bigwigsqueue = true,
		weakAurasOptions = true, 
		details = true,
		detailsresize = true,
		grid2 = true,
		-- ElvUI
		actionBarsBackdrop = true,
		actionBarsButton = true,
		afk = true,
		altPowerBar = true,
		chatDataPanels = true,
		chatPanels = true,
		chatVoicePanel = true,
		chatCopyFrame = true,
		lootRoll = true,
		options = true,
		panels = true,
		raidUtility = true,
		staticPopup = true,
		statusReport = true,
		totemTracker = true,
		Minimap = true,
		dataPanels = true,
	},
}
