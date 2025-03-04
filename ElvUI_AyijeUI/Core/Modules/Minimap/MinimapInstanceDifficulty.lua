local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local ID = E:NewModule("InstanceDifficulty", "AceEvent-3.0", "AceHook-3.0")
local M = E:GetModule("Minimap")
local EP = LibStub("LibElvUIPlugin-1.0") 
local LSM = E.Libs.LSM

local _G = _G
local format = format
local gsub = gsub
local pairs = pairs
local select = select

local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local MinimapCluster = MinimapCluster
local IsInInstance = IsInInstance

function ID:UpdateFrame()
    local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
    local inInstance, instanceType = IsInInstance()
    local difficulty = select(3, GetInstanceInfo())
    local numplayers = select(9, GetInstanceInfo())
    local mplusdiff = select(1, C_ChallengeMode_GetActiveKeystoneInfo()) or ""

    if instanceType == "party" or instanceType == "raid" or instanceType == "scenario" then
        local text = ID:GetTextForDifficulty(difficulty)

        if text then
            text = gsub(text, "%%mplus%%", mplusdiff)
            text = gsub(text, "%%numPlayers%%", numplayers)
        end
        
        self.frame.text:SetText(text)
    elseif instanceType == "pvp" or instanceType == "arena" then
        self.frame.text:SetText(ID:GetTextForDifficulty(-1))
    else
        self.frame.text:SetText("")
    end

    self.frame:SetShown(inInstance)
end

local function GetDefaultInstanceDifficultyText(difficulty, numplayers, mplusdiff)
    local norm = format("|cff1eff00%s|r", "N")
    local hero = format("|cff0070dd%s|r", "H")
    local lfr = format("|cffff8000%s|r", "LFR")
    local myth = format("|cffa335ee%s|r", "M")
    local mplus = format("|cffff3860%s|r", "M")
    
    if difficulty == 1 then -- Normal
        return "5" .. norm 
    elseif difficulty == 2 then -- Heroic
        return "5" .. hero
    elseif difficulty == 3 then -- 10 Player
        return "10" .. norm
    elseif difficulty == 4 then -- 25 Player
        return "10" .. norm
    elseif difficulty == 5 then -- 10 Player (Heroic)
        return "10" .. hero
    elseif difficulty == 6 then -- 25 Player (Heroic)
        return "25" .. hero
    elseif difficulty == 8 then -- Mythic Keystone
        return mplus .. "+" .. mplusdiff
    elseif difficulty == 14 then -- Normal Raid
        return numplayers .. norm
    elseif difficulty == 15 then -- Heroic Raid
        return numplayers .. hero
    elseif difficulty == 16 then -- Mythic Raid
        return numplayers .. myth
    elseif difficulty == 17 then -- LFR
        return numplayers .. lfr
    elseif difficulty == 23 then -- Mythic Party
        return numplayers .. myth
    end
end

function ID:GetTextForDifficulty(difficulty)
    local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
    local inInstance, instanceType = IsInInstance()
    if not inInstance then
        return 
    end
    
    local numplayers = select(9, GetInstanceInfo())
    local mplusdiff = select(1, C_ChallengeMode_GetActiveKeystoneInfo()) or ""

    return GetDefaultInstanceDifficultyText(difficulty, numplayers, mplusdiff)
end


function ID:ConstructFrame()
    if not self.db then
        return
    end

    local frame = CreateFrame("Frame", "AYIJEInstanceDifficultyFrame", _G.Minimap)
    frame:Size(30, 20)
    frame:Point("TOPLEFT", M.MapHolder, "TOPLEFT", 10, -10)

    local text = frame:CreateFontString(nil, "OVERLAY")
    -- Get the user's font settings
    local fontName = E.LSM:Fetch("font", E.db.AYIJE.minimapid.font.name)
    local fontStyle = E.db.AYIJE.minimapid.font.style
    local fontSize = E.db.AYIJE.minimapid.font.size or 20

    -- Set the font settings
    text:SetFont(fontName, fontSize, fontStyle)

    text:Point(self.db.align or "LEFT")
    frame.text = text

    E:CreateMover(
        frame,
        "PHInstanceDifficultyFrameMover",
        L["Instance Difficulty"],
        nil,
        nil,
        nil,
        "ALL,AYIJE",
        function()
            return E.db.AYIJE.minimapid.difficulty.enable
        end,
        "AYIJE,maps"
    )

    self.frame = frame
end

function ID:HideBlizzardDifficulty(difficultyFrame, isShown)
	if not self.db or not self.db.hideBlizzard or not isShown then
		return
	end

	difficultyFrame:Hide()
end

function ID:ADDON_LOADED(_, addon)
	if addon == "Blizzard_Minimap" then
		self:UnregisterEvent("ADDON_LOADED")

		local difficulty = _G.MinimapCluster.InstanceDifficulty
		for _, frame in pairs({ difficulty.Default, difficulty.Guild, difficulty.ChallengeMode }) do
			frame:SetAlpha(0)
		end
	end
end

function ID:Initialize()
    
    if not E.Retail then return end
    
    self.db = E.db.AYIJE.minimapid

    if not self.db or not self.db.enable then
        return
    end


    local difficulty = MinimapCluster.InstanceDifficulty.Default
    local instanceFrame = difficulty.Instance
    local guildFrame = difficulty.Guild
    local challengeModeFrame = difficulty.ChallengeMode
    local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

    for _, frame in pairs({difficulty, instanceFrame, guildFrame, challengeModeFrame}) do
        if frame then
            frame:Hide()
            self:SecureHook(frame, "SetShown", "HideBlizzardDifficulty")
        end
    end

    self:ConstructFrame()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_START", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_RESET", "UpdateFrame")
	self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "UpdateFrame")
	self:RegisterEvent("GUILD_PARTY_STATE_UPDATED", "UpdateFrame")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateFrame")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateFrame")

    if C_AddOns_IsAddOnLoaded("Blizzard_Minimap") then
		self:ADDON_LOADED("ADDON_LOADED", "Blizzard_Minimap")
	else
		self:RegisterEvent("ADDON_LOADED")
	end
end

E:RegisterModule(ID:GetName())
