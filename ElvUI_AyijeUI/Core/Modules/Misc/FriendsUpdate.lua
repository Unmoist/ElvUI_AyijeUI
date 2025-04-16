local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI);
local FU = E:NewModule('FriendsUpdate', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local BNConnected = BNConnected
local FriendsFrame_Update = FriendsFrame_Update
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex
local TimerunningUtil_AddSmallIcon = TimerunningUtil.AddSmallIcon
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

local WOW_PROJECT_BURNING_CRUSADE_CLASSIC = 5
local WOW_PROJECT_CLASSIC = 2
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local WOW_PROJECT_WRATH_CLASSIC = 11
local WOW_PROJECT_CATACLYSM_CLASSIC = 14

local projectCodes = {
	["ANBS"] = "Diablo Immortal",
	["Hero"] = "Heroes of the Storm",
	["OSI"] = "Diablo II",
	["S2"] = "StarCraft II",
	["VIPR"] = "Call of Duty: Black Ops 4",
	["W3"] = "WarCraft III",
	["APP"] = "Battle.net App",
	["FORE"] = "Call of Duty: Vanguard",
	["LAZR"] = "Call of Duty: MW2 Campaign Remastered",
	["RTRO"] = "Blizzard Arcade Collection",
	["WLBY"] = "Crash Bandicoot 4: It's About Time",
	["WTCG"] = "Hearthstone",
	["ZEUS"] = "Call of Duty: Blac Ops Cold War",
	["D3"] = "Diablo III",
	["GRY"] = "Warcraft Arclight Rumble",
	["ODIN"] = "Call of Duty: Mordern Warfare II",
	["S1"] = "StarCraft",
	["WOW"] = "World of Warcraft",
	["PRO"] = "Overwatch",
	["PRO-ZHCN"] = "Overwatch",
}

local expansionData = {
	[WOW_PROJECT_MAINLINE] = {
		name = "Retail",
		suffix = nil,
		maxLevel = GetMaxLevelForPlayerExpansion(),
	},
	[WOW_PROJECT_CLASSIC] = {
		name = "Classic",
		suffix = "Classic",
		maxLevel = 60,
	},
	[WOW_PROJECT_BURNING_CRUSADE_CLASSIC] = {
		name = "TBC",
		suffix = "TBC",
		maxLevel = 70,
	},
	[WOW_PROJECT_WRATH_CLASSIC] = {
		name = "WotLK",
		suffix = "WotLK",
		maxLevel = 80,
	},
	[WOW_PROJECT_CATACLYSM_CLASSIC] = {
		name = "Cata",
		suffix = "Cata",
		maxLevel = 85,
	},
}

local function GetClassColor(className)
	for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		if className == localizedName then
			return C_ClassColor_GetClassColor(class)
		end
	end
end

function GetFormattedClassColor(colorTable)
	return string.format("|cff%02x%02x%02x", colorTable.r * 255, colorTable.g * 255, colorTable.b * 255)
end

function FU:UpdateFriendButton(button)
	if button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER then
			return
	end

	local gameName, realID, name, server, class, area, level, note, faction, status, wowID, timerunningSeasonID

	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
			-- WoW friends
			wowID = WOW_PROJECT_MAINLINE
			gameName = projectCodes["WOW"]
			local friendInfo = C_FriendList_GetFriendInfoByIndex(button.id)
			name, server = strsplit("-", friendInfo.name) -- server is nil if it's not a cross-realm friend
			level = friendInfo.level
			class = friendInfo.className
			area = friendInfo.area
			note = friendInfo.notes
			faction = E.myfaction -- friend should be in the same faction

			if friendInfo.connected then
					if friendInfo.afk then
							status = "AFK"
					elseif friendInfo.dnd then
							status = "DND"
					else
							status = "Online"
					end
			else
					status = "Offline"
			end
	elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
			-- Battle.net friends
			local friendAccountInfo = C_BattleNet_GetFriendAccountInfo(button.id)
			if friendAccountInfo then
					realID = friendAccountInfo.accountName
					note = friendAccountInfo.note

					local gameAccountInfo = friendAccountInfo.gameAccountInfo
					gameName = projectCodes[strupper(gameAccountInfo.clientProgram)]

					if gameAccountInfo.isOnline then
							if friendAccountInfo.isAFK or gameAccountInfo.isGameAFK then
									status = "AFK"
							elseif friendAccountInfo.isDND or gameAccountInfo.isGameBusy then
									status = "DND"
							else
									status = "Online"
							end
					else
							status = "Offline"
					end

					-- Fetch version if friend playing WoW
					if gameName == "World of Warcraft" then
							wowID = gameAccountInfo.wowProjectID
							name = gameAccountInfo.characterName or ""
							level = gameAccountInfo.characterLevel or 0
							faction = gameAccountInfo.factionName or ""
							class = gameAccountInfo.className or ""
							area = gameAccountInfo.areaName or ""
							timerunningSeasonID = gameAccountInfo.timerunningSeasonID or ""

							if wowID and wowID ~= 1 and expansionData[wowID] then
									local suffix = expansionData[wowID].suffix and " (" .. expansionData[wowID].suffix .. ")" or ""
									local serverStrings = { strsplit(" - ", gameAccountInfo.richPresence) }
									server = (serverStrings[#serverStrings] or BNET_FRIEND_TOOLTIP_WOW_CLASSIC .. suffix) .. "*"
							elseif wowID and wowID == 1 and name == "" then
									server = gameAccountInfo.richPresence -- Plunderstorm
							else
									server = gameAccountInfo.realmDisplayName or ""
							end
					end
			end
	end

	-- Reset game icon with ElvUI style
	button.gameIcon:SetTexCoord(0, 1, 0, 1)

	if gameName then
			-- Generate the button title text
			local classColor = GetClassColor(class)
			local formattedClassColor = classColor and GetFormattedClassColor(classColor) or ""
			local nameString = formattedClassColor .. (name or "") .. "|r" -- Reset color after name
			if timerunningSeasonID ~= "" and nameString ~= nil then
					nameString = TimerunningUtil_AddSmallIcon(nameString) or nameString -- Add timerunning tag
			end

			local buttonTitle = (realID and realID .. " " or "") .. (nameString or "")

			button.name:SetText(buttonTitle)
	end
end


function FU:Initialize()

	FU:SecureHook("FriendsFrame_UpdateFriendButton", "UpdateFriendButton")


end

E:RegisterModule(FU:GetName());
