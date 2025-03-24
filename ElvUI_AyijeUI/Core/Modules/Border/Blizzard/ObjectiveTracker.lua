local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

local function ReskinObjectiveTrackerBlockRightEdgeButton(_, block)
	local frame = block.rightEdgeFrame
	if not frame then
		return
	end

	if frame.template == "QuestObjectiveFindGroupButtonTemplate" and not frame.IsBorder then
		frame:GetNormalTexture():SetAlpha(0)
		frame:GetPushedTexture():SetAlpha(0)
		frame:GetHighlightTexture():SetAlpha(0)
		S:HandleButton(frame, nil, nil, nil, true)
		frame.backdrop:SetInside(frame, 4, 4)
		BORDER:CreateBorder(frame)
		frame.IsBorder = true
	end
end

local function ReskinObjectiveTrackerBlock(_, block)
	for _, button in pairs {block.ItemButton, block.itemButton} do
		BORDER:CreateBorder(button)
	end

	ReskinObjectiveTrackerBlockRightEdgeButton(_, block)

	if block.AddRightEdgeFrame and not block.IsBorder then
		BORDER:SecureHook(block, "AddRightEdgeFrame", ReskinObjectiveTrackerBlockRightEdgeButton)
		block.IsBorder = true
	end
end

local function ReskinQuestIcon(button)
	if not button then return end

	if not button.IsBorder then

		local icon = button.icon or button.Icon
		if icon then
			BORDER:HandleIcon(icon)
		end

		button.IsBorder = true
	end
end

local function HandleQuestIcons(_, block)
	ReskinQuestIcon(block.ItemButton)
	ReskinQuestIcon(block.itemButton)
end

local function ReskinBarTemplate(bar)
	BORDER:CreateBorder(bar)
end

local function HandleProgressBar(tracker, key)
	local progressBar = tracker.usedProgressBars[key]
	local bar = progressBar and progressBar.Bar

	if bar then
		ReskinBarTemplate(bar)
	end
	local icon = bar and bar.Icon
	if icon then
		BORDER:HandleIcon(icon)
	end
end

local function HandleTimers(tracker, key)
	local timerBar = tracker.usedTimerBars[key]
	local bar = timerBar and timerBar.Bar

	if bar then
		ReskinBarTemplate(bar)
	end
end

function S:ReskinOjectiveTrackerHeader(header)
	if not header or not header.Text then return end

	header.Text:SetFont(E.db.general.fonts.objective.font, E.db.general.fonts.objective.size, E.db.general.fonts.objective.outline)
end

function S:Blizzard_ObjectiveTracker()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.objectiveTracker) then return end

	local MainHeader = _G.ObjectiveTrackerFrame.Header
	local MainMinimize = MainHeader.MinimizeButton
	BORDER:CreateBorder(MainMinimize, nil, nil, nil, nil, nil, false, true)
	MainMinimize:CreateBackdrop('Transparent')
	for _, tracker in pairs(trackers) do  
		if tracker.Header.MinimizeButton then
			tracker.Header.MinimizeButton:CreateBackdrop('Transparent')
			BORDER:CreateBorder(tracker.Header.MinimizeButton, nil, nil, nil, nil, nil, false, true)
		end

		for _, block in pairs(tracker.usedBlocks or {}) do
			ReskinObjectiveTrackerBlock(tracker, block)
		end

		BORDER:SecureHook(tracker, 'AddBlock', HandleQuestIcons)
		BORDER:SecureHook(tracker, 'GetProgressBar', HandleProgressBar)
		BORDER:SecureHook(tracker, 'GetTimerBar', HandleTimers)
	end

    E:Delay(0, function()
		for _, child in ipairs({_G.WorldQuestObjectiveTracker.ContentsFrame:GetChildren()}) do
			if child.icon and not child.IsBorder then
				BORDER:CreateBorder(child.icon)
				child.IsBorder = true
			end
		end
    end)

	local MainHeader = _G.ObjectiveTrackerFrame.Header
	S:ReskinOjectiveTrackerHeader(MainHeader)

	for _, tracker in pairs(trackers) do
		S:ReskinOjectiveTrackerHeader(tracker.Header)
	end
end

S:AddCallbackForAddon('Blizzard_ObjectiveTracker')
