local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

local strfind, strmatch, utf8lower, utf8sub = strfind, strmatch, string.utf8lower, string.utf8sub
local gmatch, gsub, format, tonumber, strsplit = gmatch, gsub, format, tonumber, strsplit

local UnitIsGroupLeader = UnitIsGroupLeader
local GetRaidTargetIndex = GetRaidTargetIndex
local UNIT_TARGET = UNIT_TARGET
local UNIT_HEALTH = UNIT_HEALTH
local UNIT_NAME_UPDATE = UNIT_NAME_UPDATE

-- Hex colors for raid markers
local markerToHex = {
	[1] = "|cFFEAEA0D", -- Yellow Star
	[2] = "|cFFEAB10D", -- Orange Circle
	[3] = "|cFFCD00FF", -- Purple Diamond
	[4] = "|cFF06D425", -- Green Triangle
	[5] = "|cFFB3E3D8", -- Light Blue Moon
	[6] = "|cFF0CD2EA", -- Blue Square
	[7] = "|cFFD6210B", -- Red Cross
	[8] = "|cFFFFFFFF", -- White Skull
}

-- Words to remove from names
local nameBlacklist = {
	["the"] = true, ["of"] = true, ["Tentacle"] = true,
	["Apprentice"] = true, ["Denizen"] = true, ["Emissary"] = true,
	["Howlis"] = true, ["Terror"] = true, ["Totem"] = true,
	["Waycrest"] = true, ["Aspect"] = true
}

E:AddTag("Ayije:name", "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_TARGET PLAYER_FLAGS_CHANGED RAID_TARGET_UPDATE", function(unit)
	local name = UnitName(unit)
	if not name then
			return ""
	end
	
	local a, b, c, d, e, f = strsplit(" ", name, 5)

	if nameBlacklist[b] then
			name = a or b or c or d or e or f or name
	else
			name = f or e or d or c or b or a or name
	end

	local marker = GetRaidTargetIndex(unit)
	if marker and markerToHex[marker] then
			name = markerToHex[marker] .. name .. "|r"
	end

	return name
end)

E:AddTag('Ayije:perpp', 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_CONNECTION', function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	local powerType = UnitPowerType(unit)
	local cur = UnitPower(unit, powerType)
	local max = UnitPowerMax(unit, powerType)
	local curper = (UnitPower(unit, powerType)/UnitPowerMax(unit, powerType))*100

	if (status) or (powerType ~= 0 and cur == 0) then
			return nil
	else
			return format("%.0f", curper)
	end
end)
