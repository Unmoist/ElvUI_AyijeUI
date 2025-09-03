local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')
local LGF = LibStub("LibGetFrame-1.0")

local S = E:GetModule('Skins')
local _G = _G
local pairs = pairs

if E.db.forceSeparators == nil then
    E.db.forceSeparators = false
end

local function CleanupIndividualFrameBorders()
    -- Clean up individual unit frame borders when transitioning to raid
    for o = 1, 2 do
        for u = 1, 5 do
            local unitName = "Grid2LayoutHeader" .. o .. "UnitButton" .. u
            local unitButton = _G[unitName]
            
            if unitButton then
                -- Remove individual borders
                if unitButton.border then 
                    unitButton.border:Hide()
                    unitButton.border:ClearAllPoints()
                    unitButton.border:SetParent(nil)
                    unitButton.border = nil
                    unitButton.IsBorder = false
                end
                
                -- Remove separators
                if unitButton.separator then
                    unitButton.separator:Hide()
                    unitButton.separator:ClearAllPoints()
                    unitButton.separator:SetParent(nil)
                    unitButton.separator = nil
                end
            end
        end
    end
end

local function GetUnitFrame()
    local spec = GetSpecialization()
    local specID = GetSpecializationInfo(spec)
    local healerSpecs = {
        [105] = true, -- Restoration(Druid)
        [270] = true, -- Mistweaver(Monk)
        [65]  = true, -- Holy(Paladin)
        [257] = true, -- Holy(Priest)
        [256] = true, -- Discipline(Priest)
        [264] = true, -- Restoration(Shaman)
        [1468] = true, -- Preservation(Evoker)
    }

    if IsInRaid() then
        -- Clean up individual frame borders first before creating layout frame border
        CleanupIndividualFrameBorders()
        BORDER:CreateBorder(_G.Grid2LayoutFrame)
        return
    else
        if healerSpecs[specID] then
            for i = 1, 2 do
                for k = 1, 5 do -- Start at 1 now
                    local unitName = "Grid2LayoutHeader" .. i .. "UnitButton" .. k
                    local unitButton = _G[unitName]

                    BORDER:CreateBorder(_G.Grid2LayoutFrame)

                    if unitButton then 
                        -- Always try to remove border
                        if unitButton.border then 
                            unitButton.border:Hide()
                            unitButton.border = nil
                            unitButton.IsBorder = false
                        end

                        -- Only affect separator if k > 1
                        if k > 1 then
                            if not IsInRaid() or E.db.forceSeparators then
                                BORDER:CreateSeparator(unitButton)
                                unitButton.separator:Show()
                                unitButton.separator:SetPoint("TOPRIGHT", unitButton, 0, 3)
                            elseif unitButton.separator then
                                unitButton.separator:Hide()
                            end
                        end
                    end
                end
            end
        else
            for o = 1, 2 do
                for u = 1, 5 do
                    local unitName = "Grid2LayoutHeader" .. o .. "UnitButton" .. u
                    local unitButton = _G[unitName]

                    if unitButton then
                        if unitButton.separator then
                            unitButton.separator:Hide()
                            unitButton.separator = nil
                        end
                    if _G.Grid2LayoutFrame.border then
                        _G.Grid2LayoutFrame.border:Hide()
                        _G.Grid2LayoutFrame.border:ClearAllPoints()
                        _G.Grid2LayoutFrame.border:SetParent(nil)
                        _G.Grid2LayoutFrame.border = nil
                        _G.Grid2LayoutFrame.IsBorder = false
                    end
                        
                        BORDER:CreateBorder(unitButton)
                        unitButton.border:SetIgnoreParentAlpha(true)
                    end
                end
            end
        end 
    end    
end

-- Slash command
SLASH_GRID2SEPARATOR1 = "/grid2separator"
SlashCmdList["GRID2SEPARATOR"] = function(msg)
    msg = msg:lower()
    if msg == "on" then
        E.db.forceSeparators = true
        Engine:Print("|cff00ff00Forced separators ON.")
        GetUnitFrame()
    elseif msg == "off" then
        E.db.forceSeparators = false
        Engine:Print("|cffff0000Forced separators OFF.")
        GetUnitFrame()
    else
        Engine:Print("|cffffff00Usage: /grid2separator on|off")
    end
end

local function Grid2GetUnitFrame()
    GetUnitFrame()
end

function S:Grid2()
    if not E.db.AYIJE.skins.grid2 then return end

    local Grid2Layout = Grid2:GetModule("Grid2Layout")
    local Grid2 = Grid2

    hooksecurefunc(Grid2Layout, "LoadLayout", Grid2GetUnitFrame)
	S:RegisterEvent("PLAYER_TALENT_UPDATE", Grid2GetUnitFrame)

    -- Reminder after /reload if separators are forced on
    E:Delay(1, function()
        if E.db.forceSeparators then
            Engine:Print("|cffffff00Reminder: Forced separators are ON. Use /grid2separator off to disable.")
        end
    end)
end

S:AddCallbackForAddon("Grid2")