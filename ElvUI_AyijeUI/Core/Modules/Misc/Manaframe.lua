local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local _G = _G
local LSM = E.Libs.LSM

local MF = E:NewModule('Mana Frame', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local BORDER = E:GetModule('BORDER')
local UF = E:GetModule('UnitFrames')

local function ShortenNumber(value)
	if value >= 1e6 then
			return string.format("%.1fm", value / 1e6) -- Millions
	elseif value >= 1e3 then
			return string.format("%.1fk", value / 1e3) -- Thousands
	else
			return tostring(value) -- Less than 1000
	end
end

local function UpdateManaBar()
	local power, maxPower
	local powerType
	
	if UnitHasVehicleUI("player") then
			powerType = UnitPowerType("vehicle")
			power = UnitPower("vehicle", powerType)
			maxPower = UnitPowerMax("vehicle", powerType)
			energycolor = {
					r =  E.db.unitframe.colors.power.ENERGY.r,
					g =  E.db.unitframe.colors.power.ENERGY.g,
					b =  E.db.unitframe.colors.power.ENERGY.b
			}
			Manaframe.manaBar:SetStatusBarColor(energycolor.r, energycolor.g, energycolor.b)
	else
			powerType = UnitPowerType("player") -- Get the player's current power type		
		
			power = UnitPower("player", powerType)
			maxPower = UnitPowerMax("player", powerType)
	end
	
	local powerPercent = math.floor((power / maxPower) * 100) -- Calculate the percentage of power
	
	Manaframe.manaBar:SetMinMaxValues(0, maxPower)
	Manaframe.manaBar:SetValue(power)
	
	if powerType == 0 then -- mana
			manacolor = {
					r =  E.db.unitframe.colors.power.MANA.r,
					g =  E.db.unitframe.colors.power.MANA.g,
					b =  E.db.unitframe.colors.power.MANA.b
			}

			Manaframe.manaBar:SetStatusBarColor(manacolor.r, manacolor.g, manacolor.b)
	end
	
	Manaframe.percentText:Show() -- Show the text all the time
	Manaframe.percentText:SetText(powerPercent) -- Show percentage for other power types

	Manaframe.totalText:Show() -- Show the text all the time
	Manaframe.totalText:SetText(ShortenNumber(power)) -- Show current mana in shortened format

	if E.db.AYIJE.manaFrame.glowline then
		if powerPercent > 0 and powerPercent < 100 then
				Manaframe.glowLine:Show() -- Show the glow line if power is between 0% and 100%
				local glowPosition = (power / maxPower) * Manaframe:GetWidth() -- Calculate the position of the glow line
				Manaframe.glowLine:SetPoint("CENTER", Manaframe.manaBar, "LEFT", glowPosition - 1.5, 0) -- Set the glow line position
		else
				Manaframe.glowLine:Hide() -- Hide the glow line if power is 100% or 0%
		end
	end
end

local function PortraitManaBar()
	local ManaBarPlayerPortrait
	local ManaBarPlayerframeEvent = CreateFrame("Frame")
	ManaBarPlayerframeEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
	ManaBarPlayerframeEvent:RegisterEvent("PORTRAITS_UPDATED")
	ManaBarPlayerframeEvent:SetScript("OnEvent", function(self, event)
			if ManaBarPlayerPortrait then
					ManaBarPlayerPortrait:Hide()
					ManaBarPlayerPortrait = nil
			end
			if UnitExists("player") then
				
					local playerHeight = _G.Manaframe:GetHeight()
					ManaBarPlayerPortrait = CreateFrame("Frame", nil, Manaframe, "BackdropTemplate")
					ManaBarPlayerPortrait:SetSize(playerHeight + 20, playerHeight + 20)
					ManaBarPlayerPortrait:SetPoint("RIGHT", Manaframe, "LEFT", 7, 0)
					ManaBarPlayerPortrait:SetFrameLevel(Manaframe:GetFrameLevel() + 2)

					local ManaBarPlayerPortraitTexture = ManaBarPlayerPortrait:CreateTexture(nil, "OVERLAY")
					ManaBarPlayerPortraitTexture:SetAllPoints(ManaBarPlayerPortrait)
					ManaBarPlayerPortraitTexture:SetTexture(Engine.Portrait)
					SetPortraitTexture(ManaBarPlayerPortraitTexture, 'player')

					local ManaBarPlayerPortraitBorder = CreateFrame("Frame", nil, ManaBarPlayerPortrait, "BackdropTemplate")
					ManaBarPlayerPortraitBorder:SetSize(ManaBarPlayerPortrait:GetHeight() + 60, ManaBarPlayerPortrait:GetWidth() + 60)
					ManaBarPlayerPortraitBorder:SetPoint("CENTER", ManaBarPlayerPortrait, "CENTER")

					local ManaBarPlayerPortraitBorderTexture = ManaBarPlayerPortraitBorder:CreateTexture(nil, "OVERLAY")
					ManaBarPlayerPortraitBorderTexture:SetAllPoints(ManaBarPlayerPortraitBorder)
					ManaBarPlayerPortraitBorderTexture:SetTexture(Engine.PortraitBorder)
					ManaBarPlayerPortraitBorderTexture:SetVertexColor(1, 1, 1, 1)
					ManaBarPlayerPortraitBorderTexture:SetDesaturated(true)

					local _, unitClass = UnitClass("player")
					local isPlayer = UnitIsPlayer("player")
					local color

					if isPlayer then
							color = ElvUF.colors.class[unitClass]
					else
							color = ElvUF.colors.reaction[UnitReaction("player", 'player')]
					end

					ManaBarPlayerPortraitBorderTexture:SetVertexColor((color and color.r) or 0.8, (color and color.g) or 0.8, (color and color.b) or 0.8, 1)
			end
	end)
end

function MF:Initialize()
	if E.db.unitframe.units.player.enable then return end
	if not E.db.AYIJE.manaFrame.enable then return end

	local width = E.db.AYIJE.manaFrame.width
	local height = E.db.AYIJE.manaFrame.height

	ManaFrameAnchor = CreateFrame("Frame", "ManaFrameAnchor", E.UIParent, 'BackdropTemplate')
	ManaFrameAnchor:Point('CENTER', UIParent, 'CENTER')
	ManaFrameAnchor:Size(width, height)
	ManaFrameAnchor:SetFrameStrata("BACKGROUND")

	E:CreateMover(ManaFrameAnchor, "Ayije: Mana Frame", "ManaframeMover", nil, nil, nil, "ALL")

	Manaframe = CreateFrame("Frame", "Ayije_ManaFrame", UIParent, "BackdropTemplate")
	Manaframe:Size(width, height)
	Manaframe:SetPoint("CENTER", ManaFrameAnchor, 0, 0)
	Manaframe:SetTemplate("Transparent")

	BORDER:CreateBorder(_G.Manaframe)

	local button = CreateFrame("Button","Ayije: Mana Frame", Manaframe,"SecureUnitButtonTemplate")
	button:SetAllPoints()
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetAttribute("unit","player")
	button:SetAttribute("type1","target")
	button:SetAttribute("type2", "togglemenu")
	button:EnableMouse(true)

	Manaframe.manaBar = CreateFrame("StatusBar", nil, Manaframe)
	Manaframe.manaBar:SetMinMaxValues(0, 1)
	Manaframe.manaBar:SetValue(0)
	Manaframe.manaBar:SetAllPoints(true)
	local statusBarTexture = LSM:Fetch('statusbar', UF.db.statusbar)
	Manaframe.manaBar:SetStatusBarTexture(statusBarTexture)

	Manaframe.percentTextFrame = CreateFrame("Frame", nil, Manaframe)
	Manaframe.percentTextFrame:SetSize(16, 37)
	Manaframe.percentTextFrame:SetFrameLevel(Manaframe:GetFrameLevel() + 4)

	Manaframe.totalTextFrame = CreateFrame("Frame", nil, Manaframe)
	Manaframe.totalTextFrame:SetSize(16, 37)
	Manaframe.totalTextFrame:SetFrameLevel(Manaframe:GetFrameLevel() + 4)

	local TextfontSize = E.db.AYIJE.manaFrame.textsize
	Manaframe.percentText = Manaframe.percentTextFrame:CreateFontString(nil, "OVERLAY")
	Manaframe.percentText:SetFont(E.media.normFont, TextfontSize, E.db.general.fontStyle)
	Manaframe.percentText:SetPoint("LEFT", Manaframe.manaBar, "LEFT", 10, 0)

	Manaframe.totalText = Manaframe.totalTextFrame:CreateFontString(nil, "OVERLAY")
	Manaframe.totalText:SetFont(E.media.normFont, TextfontSize, E.db.general.fontStyle)
	Manaframe.totalText:SetPoint("RIGHT", Manaframe.manaBar, "RIGHT", -5, 0)

	if E.db.AYIJE.manaFrame.glowline then
		Manaframe.glowLine = Manaframe.manaBar:CreateTexture(nil, "OVERLAY")
		Manaframe.glowLine:SetTexture(Engine.Glowline);
		Manaframe.glowLine:SetSize(5, Manaframe:GetHeight())
		Manaframe.glowLine:SetPoint("CENTER", Manaframe.Manaframe, "LEFT", 5, 5)
		Manaframe.glowLine:SetBlendMode("ADD")
	end
	
	local events = {
		"UNIT_POWER_UPDATE",
		"UNIT_ENTERING_VEHICLE",
		"UNIT_EXITING_VEHICLE",
	}

	for _, event in ipairs(events) do
		Manaframe:RegisterEvent(event)
	end

	Manaframe:SetScript("OnEvent", function(self, event, ...)
			UpdateManaBar()
	end)

	UpdateManaBar()
	PortraitManaBar()
end

E:RegisterModule(MF:GetName());