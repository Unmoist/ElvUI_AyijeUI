local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local M = E:GetModule("Misc")

local _G = _G
local pairs = pairs
local tinsert = tinsert
local unpack = unpack

function S:ElvUI_SkinLootRollFrame(frame)
    if not frame or frame:IsForbidden() then
        return
    end

    frame.button.__Point = frame.button.Point
    frame.button.Point = function(f, anchor, parent, point, x, y)
        if anchor == "RIGHT" and parent == frame and point == "LEFT" then
            f:__Point(anchor, parent, point, x and x - 4, y)
        else
            f:__Point(anchor, parent, point, x, y)
        end
    end

    local points = {}
    for i = 1, frame.button:GetNumPoints() do
        tinsert(points, {frame.button:GetPoint(i)})
    end

    if #points > 0 then
        frame.button:ClearAllPoints()
        for _, point in pairs(points) do
            frame.button:Point(unpack(point))
        end
    end

    BORDER:CreateBorder(frame.button.backdrop)
    BORDER:CreateBorder(frame.status.backdrop)


    E:Delay(1,
    function()
        local r, g, b = unpack(E.media.backdropfadecolor)

        frame.button:ClearAllPoints()
		frame.button:Point('RIGHT', frame, 'LEFT', -5, 0)
        frame.status.backdrop:SetBackdropColor(r, g, b, 1)
    end)

end

function S:ElvUI_LootRoll()
    if not E.db.AYIJE.skins.lootRoll then return end

    S:SecureHook(
        M,
        "LootRoll_Create",
        function(_, index)
            S:ElvUI_SkinLootRollFrame(_G["ElvUI_LootRollFrame" .. index])
        end
    )

    for _, bar in pairs(M.RollBars) do
        S:ElvUI_SkinLootRollFrame(bar)
    end

    BORDER:CreateBorder(_G.ElvLootFrame)

    _G.ElvLootFrame:HookScript('OnUpdate', function()
        local numItems = GetNumLootItems()
        for i = 1, numItems do
            local slot = _G["ElvLootSlot"..i]
            local slotframe = slot.iconFrame
            if slotframe and slot.name then
                local r, g, b = slot.name:GetTextColor()

                BORDER:CreateBorder(slotframe, nil, -7, 7, 7, -7)
                slotframe.border:SetBackdropBorderColor(r, g, b)
            end
        end
    end)  
end

S:AddCallback("ElvUI_LootRoll")


--[[
local function GetLootRollTimeLeft(rollid)
	return 10.0
end
local function GetLootRollItemLink(rollID)
	return '|cffffffff|Hitem:25::::::::1:::::::::|h[Worn Shortsword]|h|r'
end
local function GetLootRollItemInfo(RollID)
	local Texture = 135226
	local Name = 'Atiesh, Greatstaff of the Guardian'
	local Count = RollID
	local Quality = RollID + 1
	local BindOnPickUp = true
	local CanNeed = true
	local CanGreed = false
	local CanDisenchant = true
	local CanTransmog = true
	local ReasonNeed = 0
	local ReasonGreed = 0
	return Texture, Name, Count, Quality, BindOnPickUp, CanNeed, CanGreed, CanDisenchant, ReasonNeed, ReasonGreed, nil, nil, CanTransmog
end

function TEST()
    local NUM_GROUP_LOOT_FRAMES = NUM_GROUP_LOOT_FRAMES or 4
	for rollID = 1, NUM_GROUP_LOOT_FRAMES do
		print("test")
	   M:START_LOOT_ROLL(_, rollID, 10)
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
    TEST()
end)
]]
-- debug note:
-- itemLink = select(2, C_Item.GetItemInfo(193652))
-- texture, name, count, quality, bop, canNeed, canGreed, canDisenchant = 123, 'test', 1, 1, true, true, true, true
-- call the function
-- E:GetModule("Misc"):START_LOOT_ROLL(_, 1, 19)
