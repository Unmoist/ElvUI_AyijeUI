local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')
local LGF = LibStub("LibGetFrame-1.0")

local S = E:GetModule('Skins')
local _G = _G
local pairs = pairs

local function GetUnitFrame()
	for i = 1, 2 do
		for k = 2, 5 do
			local unitName = "Grid2LayoutHeader" .. i .. "UnitButton" .. k
			local unitButton = _G[unitName]
			if unitButton then 
				if not IsInRaid() then
					BORDER:CreateSeparator(unitButton)
					unitButton.separator:Show()
					unitButton.separator:SetPoint("TOPRIGHT", unitButton, 0, 3)
				elseif IsInRaid() and unitButton.separator then
					unitButton.separator:Hide()
				end
			end
		end
	end
end

function S:Grid2()
  if not E.db.AYIJE.skins.grid2 then return end
	local Grid2Layout = Grid2:GetModule("Grid2Layout")
	local Grid2 = Grid2

  BORDER:CreateBorder(_G.Grid2LayoutFrame)

	hooksecurefunc(Grid2Layout, "LoadLayout", GetUnitFrame)
end

S:AddCallbackForAddon("Grid2")

-- Old code for safe keeping. 
--[[
local function GetUnitFrame()
	if IsInRaid() then return end

	local partyFrames = {
			LGF.GetUnitFrame("player", { raidFrames = "^Grid2Layout" }),
			LGF.GetUnitFrame("party1", { raidFrames = "^Grid2Layout" }),
			LGF.GetUnitFrame("party2", { raidFrames = "^Grid2Layout" }),
			LGF.GetUnitFrame("party3", { raidFrames = "^Grid2Layout" }),
			LGF.GetUnitFrame("party4", { raidFrames = "^Grid2Layout" })
	}

	for _, frame in pairs(partyFrames) do
			if (frame and _G.Grid2LayoutHeader1UnitButton1 and frame:GetName() == _G.Grid2LayoutHeader1UnitButton1:GetName()) or (frame and _G.Grid2LayoutHeader2UnitButton1 and frame:GetName() == _G.Grid2LayoutHeader2UnitButton1:GetName()) then
				if frame.separator then
					frame.separator:Hide()
				end
			else
					if frame then
							if UnitExists(frame.unit) and not frame.SEPARATOR then
								BORDER:CreateSeparator(frame)
								frame.separator:SetPoint("TOPRIGHT", frame, 0, 3)
								frame.SEPARATOR = true
							elseif not UnitExists(frame.unit) and frame.SEPARATOR then
								if frame.separator then
									frame.separator:Hide()
									frame.SEPARATOR = nil
								end
							end
					end
			end
	end
end

local function FrameCallback(event, frame, unit)
    if event == "GETFRAME_REFRESH" or event == "FRAME_UNIT_UPDATE" or event == "FRAME_UNIT_REMOVED" then
        GetUnitFrame()
    end
end

function S:Grid2()
    if not E.db.AYIJE.skins.grid2 then return end

    BORDER:CreateBorder(_G.Grid2LayoutFrame)

    _G.Grid2LayoutFrame.border:RegisterEvent("PLAYER_ENTERING_WORLD")
    _G.Grid2LayoutFrame.border:RegisterEvent("GROUP_ROSTER_UPDATE")
    _G.Grid2LayoutFrame.border:SetScript("OnEvent", function(self, event, ...)
        GetUnitFrame()
    end)

    LGF.RegisterCallback(_G.Grid2LayoutFrame, "GETFRAME_REFRESH", FrameCallback)
    LGF.RegisterCallback(_G.Grid2LayoutFrame, "FRAME_UNIT_UPDATE", FrameCallback)
    LGF.RegisterCallback(_G.Grid2LayoutFrame, "FRAME_UNIT_REMOVED", FrameCallback)
end

S:AddCallbackForAddon("Grid2")
]]