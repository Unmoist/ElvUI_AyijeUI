local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local _G = _G
local LSM = E.Libs.LSM

local MF = E:NewModule('Mana Frame', 'AceHook-3.0', 'AceEvent-3.0')
local BORDER = E:GetModule('BORDER')
local UF = E:GetModule('UnitFrames')

---------------------------------------------------
-- Mana Update
---------------------------------------------------
function MF:UpdateManaBar()
	if not self.Manaframe or not self.Manaframe.manaBar then return end

	local unit = UnitInVehicle("player") and "vehicle" or "player"
	local powerType = UnitInVehicle("player") and UnitPowerType("vehicle") or Enum.PowerType.Mana

	local power = UnitPower(unit, powerType)
	local maxPower = UnitPowerMax(unit, powerType)

	self.Manaframe.manaBar:SetMinMaxValues(0, maxPower)
	self.Manaframe.manaBar:SetValue(power)

	-- Power color
	if powerType == Enum.PowerType.Mana then
		local color = E.db.unitframe.colors.power.MANA
		self.Manaframe.manaBar:SetStatusBarColor(color.r, color.g, color.b)
	else
		local color = E.db.unitframe.colors.power.ENERGY
		self.Manaframe.manaBar:SetStatusBarColor(color.r, color.g, color.b)
	end

	-- Percentage text with fallback
	local powerPercent
	if UnitPowerPercent then
		powerPercent = UnitPowerPercent(unit, powerType, false, CurveConstants.ScaleTo100) or 0
	else
		-- Fallback calculation for older API versions
		powerPercent = maxPower > 0 and (power / maxPower * 100) or 0
	end

	self.Manaframe.percentText:Show()
	self.Manaframe.percentText:SetText(string.format("%.0f", powerPercent))

	self.Manaframe.totalText:Show()
	self.Manaframe.totalText:SetText(AbbreviateLargeNumbers(power))
end

---------------------------------------------------
-- Portrait
---------------------------------------------------
function MF:PortraitManaBar()
	if self.ManaBarPlayerPortrait then
		self.ManaBarPlayerPortrait:Hide()
		self.ManaBarPlayerPortrait = nil
	end

	if not UnitExists("player") or not self.Manaframe then return end

	-- Verify textures exist
	if not Engine.Portrait or not Engine.PortraitBorder then
		E:Print("Mana Frame: Portrait textures not found")
		return
	end

	local playerHeight = self.Manaframe:GetHeight()

	self.ManaBarPlayerPortrait = CreateFrame("Frame", nil, self.Manaframe, "BackdropTemplate")
	self.ManaBarPlayerPortrait:SetSize(playerHeight + 20, playerHeight + 20)
	self.ManaBarPlayerPortrait:SetPoint("RIGHT", self.Manaframe, "LEFT", 7, 0)
	self.ManaBarPlayerPortrait:SetFrameLevel(self.Manaframe:GetFrameLevel() + 16)

	local portraitTexture = self.ManaBarPlayerPortrait:CreateTexture(nil, "OVERLAY")
	portraitTexture:SetAllPoints()
	portraitTexture:SetTexture(Engine.Portrait)
	SetPortraitTexture(portraitTexture, "player")

	local border = CreateFrame("Frame", nil, self.ManaBarPlayerPortrait, "BackdropTemplate")
	border:SetSize(self.ManaBarPlayerPortrait:GetHeight() + 60, self.ManaBarPlayerPortrait:GetWidth() + 60)
	border:SetPoint("CENTER")

	local borderTexture = border:CreateTexture(nil, "OVERLAY")
	borderTexture:SetAllPoints()
	borderTexture:SetTexture(Engine.PortraitBorder)
	borderTexture:SetDesaturated(true)

	local _, unitClass = UnitClass("player")
	local color = ElvUF.colors.class[unitClass]

	borderTexture:SetVertexColor(
		(color and color.r) or 0.8,
		(color and color.g) or 0.8,
		(color and color.b) or 0.8,
		1
	)

	-- Portrait updates
	if not self.PortraitEventFrame then
		self.PortraitEventFrame = CreateFrame("Frame")
		self.PortraitEventFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
		self.PortraitEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		self.PortraitEventFrame:SetScript("OnEvent", function(_, _, unit)
			if unit and unit ~= "player" then return end
			if portraitTexture then
				SetPortraitTexture(portraitTexture, "player")
			end
		end)
	end
end

---------------------------------------------------
-- Frame Creation
---------------------------------------------------
function MF:AYIJE_Manaframe()
	if self.Manaframe then return end

	local width = E.db.AYIJE.manaFrame.width
	local height = E.db.AYIJE.manaFrame.height

	self.Manaframe = CreateFrame("Frame", "Ayije_ManaFrame", UIParent, "BackdropTemplate")
	self.Manaframe:Size(width, height)
	self.Manaframe:SetPoint("CENTER", ManaFrameAnchor)
	self.Manaframe:SetTemplate("Transparent")

	BORDER:CreateBorder(self.Manaframe)

	local button = CreateFrame("Button", "Ayije_ManaFrameButton", self.Manaframe, "SecureUnitButtonTemplate")
	button:SetAllPoints()
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetAttribute("unit", "player")
	button:SetAttribute("type1", "target")
	button:SetAttribute("type2", "togglemenu")
	button:EnableMouse(true)

	self.Manaframe.manaBar = CreateFrame("StatusBar", nil, self.Manaframe)
	self.Manaframe.manaBar:SetAllPoints()
	self.Manaframe.manaBar:SetStatusBarTexture(LSM:Fetch("statusbar", UF.db.statusbar))

	local fontSize = E.db.AYIJE.manaFrame.textsize
	local textFrameLevel = self.Manaframe:GetFrameLevel() + 10

	-- Percent text (left)
	self.Manaframe.percentTextFrame = CreateFrame("Frame", nil, self.Manaframe)
	self.Manaframe.percentTextFrame:SetFrameLevel(textFrameLevel)

	self.Manaframe.percentText = self.Manaframe.percentTextFrame:CreateFontString(nil, "OVERLAY")
	self.Manaframe.percentText:SetFont(E.media.normFont, fontSize, E.db.general.fontStyle)
	self.Manaframe.percentText:SetPoint("LEFT", self.Manaframe, "LEFT", 10, 0)
	self.Manaframe.percentText:SetJustifyH("LEFT")

	-- Total power text (right)
	self.Manaframe.totalTextFrame = CreateFrame("Frame", nil, self.Manaframe)
	self.Manaframe.totalTextFrame:SetFrameLevel(textFrameLevel)

	self.Manaframe.totalText = self.Manaframe.totalTextFrame:CreateFontString(nil, "OVERLAY")
	self.Manaframe.totalText:SetFont(E.media.normFont, fontSize, E.db.general.fontStyle)
	self.Manaframe.totalText:SetPoint("RIGHT", self.Manaframe, "RIGHT", -5, 0)
	self.Manaframe.totalText:SetJustifyH("RIGHT")

	-- Events
	self.Manaframe:RegisterEvent("UNIT_POWER_UPDATE")
	self.Manaframe:RegisterEvent("UNIT_ENTERING_VEHICLE")
	self.Manaframe:RegisterEvent("UNIT_EXITING_VEHICLE")

	self.Manaframe:SetScript("OnEvent", function(_, _, unit)
		if unit ~= "player" and unit ~= "vehicle" then return end
		MF:UpdateManaBar()
	end)

	self:UpdateManaBar()
	self:PortraitManaBar()
end

---------------------------------------------------
-- Remove
---------------------------------------------------
function MF:RemoveManaframe()
	if not self.Manaframe then return end

	-- Clean up portrait event frame
	if self.PortraitEventFrame then
		self.PortraitEventFrame:UnregisterAllEvents()
		self.PortraitEventFrame:SetScript("OnEvent", nil)
		self.PortraitEventFrame = nil
	end

	-- Clean up portrait frame
	if self.ManaBarPlayerPortrait then
		self.ManaBarPlayerPortrait:Hide()
		self.ManaBarPlayerPortrait:SetParent(nil)
		self.ManaBarPlayerPortrait = nil
	end

	-- Clean up main frame
	self.Manaframe:UnregisterAllEvents()
	self.Manaframe:SetScript("OnEvent", nil)
	self.Manaframe:Hide()
	self.Manaframe:SetParent(nil)
	self.Manaframe = nil
end

---------------------------------------------------
-- Statusbar Texture Sync
---------------------------------------------------
local function UpdateStatusBarTexture()
	if MF.Manaframe and MF.Manaframe.manaBar then
		MF.Manaframe.manaBar:SetStatusBarTexture(
			LSM:Fetch("statusbar", UF.db.statusbar)
		)
	end
end

---------------------------------------------------
-- Spec Check
---------------------------------------------------
function MF:CheckIfHealerAndRun()
	local spec = GetSpecialization()
	if not spec then return end

	local specID = GetSpecializationInfo(spec)
	local healerSpecs = {
		[105] = true,   -- Resto Druid
		[270] = true,   -- Mistweaver Monk
		[65]  = true,   -- Holy Paladin
		[257] = true,   -- Holy Priest
		[256] = true,   -- Discipline Priest
		[264] = true,   -- Resto Shaman
		[1468] = true,  -- Preservation Evoker
	}

	if healerSpecs[specID] then
		self:AYIJE_Manaframe()
	else
		self:RemoveManaframe()
	end
end

---------------------------------------------------
-- Init
---------------------------------------------------
function MF:Initialize()
	if not E.db.AYIJE.manaFrame.enable then return end

	if not ManaFrameAnchor then
		ManaFrameAnchor = CreateFrame("Frame", "ManaFrameAnchor", E.UIParent, "BackdropTemplate")
		ManaFrameAnchor:Point("CENTER", UIParent, "CENTER")
		ManaFrameAnchor:Size(E.db.AYIJE.manaFrame.width, E.db.AYIJE.manaFrame.height)
		E:CreateMover(ManaFrameAnchor, "Ayije: Mana Frame", "ManaframeMover", nil, nil, nil, "ALL")
	end

	hooksecurefunc(UF, "Update_StatusBar", UpdateStatusBarTexture)

	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "CheckIfHealerAndRun")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckIfHealerAndRun")

	self:CheckIfHealerAndRun()
end

E:RegisterModule(MF:GetName())