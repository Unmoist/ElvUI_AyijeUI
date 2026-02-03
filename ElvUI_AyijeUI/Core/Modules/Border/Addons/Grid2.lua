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
    local specID = spec and GetSpecializationInfo(spec) or nil
    local healerSpecs = {
        [105] = true, -- Restoration(Druid)
        [270] = true, -- Mistweaver(Monk)
        [65]  = true, -- Holy(Paladin)
        [257] = true, -- Holy(Priest)
        [256] = true, -- Discipline(Priest)
        [264] = true, -- Restoration(Shaman)
        [1468] = true, -- Preservation(Evoker)
    }

    -- Only perform the raid-layout cleanup and single layout border when NOT forcing separators.
    -- If forceSeparators is true we want the healer party separator creation to run even while in raid.
    if IsInRaid() and not E.db.forceSeparators then
        -- Clean up individual frame borders first before creating layout frame border
        CleanupIndividualFrameBorders()
        BORDER:CreateBorder(_G.Grid2LayoutFrame)
        return
    end

    -- At this point either we're not in raid, or forceSeparators is true.
    -- If healer spec, create separators for party frames (this runs even in raid when forced).
    if specID and healerSpecs[specID] then
        -- Create a border around the entire layout frame once
        if not _G.Grid2LayoutFrame.border then
            BORDER:CreateBorder(_G.Grid2LayoutFrame)
        else
            _G.Grid2LayoutFrame.border:Show()
        end

        for i = 1, 2 do
            for k = 1, 5 do -- Start at 1
                local unitName = "Grid2LayoutHeader" .. i .. "UnitButton" .. k
                local unitButton = _G[unitName]

                if unitButton then
                    -- Always try to remove any per-unit border that might exist
                    if unitButton.border then 
                        unitButton.border:Hide()
                        unitButton.border = nil
                        unitButton.IsBorder = false
                    end

                    -- Only create separators for k > 1 (and only if not hidden by other logic)
                    if k > 1 then
                        -- Create/show separator if not in raid OR if forceSeparators is enabled
                        if not IsInRaid() or E.db.forceSeparators then
                            if not unitButton.separator then
                                BORDER:CreateSeparator(unitButton)
                            else
                                unitButton.separator:Show()
                            end
                            -- Position separator consistently
                            if unitButton.separator then
                                unitButton.separator:SetPoint("TOPRIGHT", unitButton, 0, 3)
                            end
                        elseif unitButton.separator then
                            unitButton.separator:Hide()
                        end
                    else
                        -- ensure first column separator removed
                        if unitButton.separator then
                            unitButton.separator:Hide()
                        end
                    end
                end
            end
        end

    else
        -- Non-healer behavior: restore per-unit borders and hide separators
        for o = 1, 2 do
            for u = 1, 5 do
                local unitName = "Grid2LayoutHeader" .. o .. "UnitButton" .. u
                local unitButton = _G[unitName]

                if unitButton then
                    -- Remove separator if present
                    if unitButton.separator then
                        unitButton.separator:Hide()
                        unitButton.separator = nil
                    end

                    -- Remove layout frame border if present (we'll create per-unit borders below)
                    if _G.Grid2LayoutFrame and _G.Grid2LayoutFrame.border then
                        _G.Grid2LayoutFrame.border:Hide()
                        _G.Grid2LayoutFrame.border:ClearAllPoints()
                        _G.Grid2LayoutFrame.border:SetParent(nil)
                        _G.Grid2LayoutFrame.border = nil
                        _G.Grid2LayoutFrame.IsBorder = false
                    end

                    -- Create per-unit border
                    BORDER:CreateBorder(unitButton)
                    if unitButton.border then
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
