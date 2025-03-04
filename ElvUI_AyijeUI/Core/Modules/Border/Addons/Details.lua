local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local type = type
local unpack = unpack

-- Tables to store the references to created frames
local createdPanels = {}
local createdSeparators = {}

local function CreateDetailsBarPanel()
	-- Iterate through each barra
	for i = 1, 2 do
		for j = 1, 4 do
			local barFrame = _G["DetailsBarra_"..i.."_"..j]
			if barFrame then
				-- Remove old separators if they exist
				if createdSeparators[barFrame] then
					createdSeparators[barFrame]:Hide()
					createdSeparators[barFrame] = nil
				end
				local Panel_barSeparator = CreateFrame("Frame", nil, barFrame, "BackdropTemplate")
				Panel_barSeparator:SetHeight(16)
				Panel_barSeparator:SetBackdrop(Engine.Separator)
				Panel_barSeparator:SetFrameLevel(barFrame:GetFrameLevel() + 3)
				Panel_barSeparator:SetPoint("BOTTOMLEFT", 0, -15)
				Panel_barSeparator:SetPoint("BOTTOMRIGHT", 0, 0)
				createdSeparators[barFrame] = Panel_barSeparator
			end
		end
	end
end

local function CreatePanel(panelName, baseFrame, border, separator, background)
	-- Remove old panels if they exist
	if createdPanels[panelName] then
		createdPanels[panelName].Panel:Hide()
		createdPanels[panelName].Panel_Separator:Hide()
		createdPanels[panelName].Panel_Background:Hide()
	end

	local Panel = CreateFrame("Frame", panelName, baseFrame, "BackdropTemplate")
	Panel:SetBackdrop(Engine.Border)
	Panel:SetFrameLevel(baseFrame:GetFrameLevel() + 6)
	Panel:SetPoint("TOPLEFT", -9, 16)
	Panel:SetPoint("BOTTOMRIGHT", 9, -6)

	local Panel_Separator = CreateFrame("Frame", nil, baseFrame, "BackdropTemplate")
	Panel_Separator:SetHeight(16)
	Panel_Separator:SetBackdrop(separator)
	Panel_Separator:SetFrameLevel(baseFrame:GetFrameLevel() + 5)
	Panel_Separator:SetPoint("TOPLEFT", 0, -13)
	Panel_Separator:SetPoint("TOPRIGHT", 0, -13)

	local Panel_Background = CreateFrame("Frame", nil, baseFrame, "BackdropTemplate")
	Panel_Background:SetBackdrop(background)
	Panel_Background:SetFrameLevel(baseFrame:GetFrameLevel() - 1)
	Panel_Background:SetPoint("TOPLEFT", -1, 8)
	Panel_Background:SetPoint("BOTTOMRIGHT", 1, 0)
	Panel_Background:SetBackdropColor(0.125, 0.125, 0.125, 1)

	createdPanels[panelName] = {
		Panel = Panel,
		Panel_Separator = Panel_Separator,
		Panel_Background = Panel_Background
	}
end

local function DetailsSkin()
	for i = 1, 5 do
		if _G["DetailsBaseFrame"..i] then
			CreatePanel("Details_Panel"..i, _G["DetailsBaseFrame"..i.."FullWindowFrame"], Engine.Border, Engine.Separator, Engine.BackgroundTexture)
		end
	end

    CreateDetailsBarPanel()
end

local function DetailsResizer()
	-- Create a frame to listen for events
	local DetailsResizer = CreateFrame("Frame")
	-- Define the function that will run when the event fires
	local function eventHandler(self, event, ...)
			if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
					C_Timer.After(1.2, function()  -- Delay of 1 second
							DetailsSkin()  -- Call DetailsSkin function to update panels

							local window2 = Details:GetWindow(2)
							if (window2) then
									local currentZoneType = Details.zone_type
									if (currentZoneType == "party" or currentZoneType == "none") then
											window2:SetSize(288, 66) 
											DetailsBaseFrame2:ClearAllPoints()
											DetailsBaseFrame2:SetPoint("BOTTOMRIGHT",-53,243)
									elseif (currentZoneType == "raid") then
											window2:SetSize(288, 165) 
											DetailsBaseFrame2:ClearAllPoints()
											DetailsBaseFrame2:SetPoint("BOTTOMRIGHT",-53,243)
									end
							end
					end)
			end
	end
    
    -- Register the event with the frame
    DetailsResizer:RegisterEvent("PLAYER_ENTERING_WORLD")
    DetailsResizer:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    DetailsResizer:RegisterEvent("ZONE_CHANGED")
    DetailsResizer:RegisterEvent("ZONE_CHANGED_INDOORS")
    -- Associate the handler with the frame
    DetailsResizer:SetScript("OnEvent", eventHandler)
end

function S:Details()
    if E.db.AYIJE.skins.details then
        DetailsSkin()
    end
    
    if E.db.AYIJE.skins.detailsresize then
        DetailsResizer()
    end
end

S:AddCallbackForAddon("Details")
