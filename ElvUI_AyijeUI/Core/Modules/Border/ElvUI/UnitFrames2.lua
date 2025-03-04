local Name, Private = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local UF = E:GetModule("UnitFrames")


function ProjectHopes:UnitFramesBorders()
    if E.private.unitframe.enable then
        local function BorderAndSeparator(f)
            if f then
                if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
                    if f.border then
                        f.border:Hide()
                    end
        
                    BORDER:CreateBorder(f.Health)
                else
                    if f.Health.border then
                        f.Health.border:Hide()
                    end

                    BORDER:CreateBorder(f, 15)
                end

                if f.USE_POWERBAR and (f.border or f.Health.border) then
                    local border = f.Power.border
                    local separator = f.Power.separator
                    if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
                        if not border then
                            BORDER:CreateBorder(f.Power)
                        else
                            border:Show()
                        end
                        if separator then
                            separator:Hide()
                        end
                    else
                        if not separator then
                            BORDER:CreateSeparator(f.Power)
                        else
                            separator:Show()
                        end
                        if border then
                            border:Hide()
                        end
                    end
                end
            end
        end

        -- Party
        if E.db.ProjectHopes.border.Party and E.db.unitframe.units.party.enable then
            BORDER:CreateBorder(_G.ElvUF_PartyGroup1, 20, -9, 9, 9, -9)

            local PartyBackground = CreateFrame("Frame", nil, _G.ElvUF_PartyGroup1, BackdropTemplateMixin and "BackdropTemplate")
            PartyBackground:SetBackdrop(Private.BackgroundTexture)
            PartyBackground:SetFrameLevel(_G.ElvUF_PartyGroup1:GetFrameLevel() + 1)
            PartyBackground:SetPoint("TOPLEFT", _G.ElvUF_PartyGroup1, -2, 2)
            PartyBackground:SetPoint("BOTTOMRIGHT", _G.ElvUF_PartyGroup1, 2, -2)
            PartyBackground:SetBackdropColor(0.1254901960784314, 0.1254901960784314, 0.1254901960784314)

            if E.db.unitframe.units.party.growthDirection == "UP_RIGHT" or E.db.unitframe.units.party.growthDirection == "UP_LEFT" or E.db.unitframe.units.party.growthDirection == "DOWN_LEFT" or E.db.unitframe.units.party.growthDirection == "DOWN_RIGHT" then
                for i = 2, 5 do
                    BORDER:CreateSeparator(_G["ElvUF_PartyGroup1UnitButton"..i], 22, nil, _G.ElvUF_PartyGroup1)
                end
            else
                for i = 2, 5 do
                    BORDER:CreateVSeparator(_G["ElvUF_PartyGroup1UnitButton"..i], 22, nil, _G.ElvUF_PartyGroup1)
                end
            end
        end

        -- Raid
        if E.db.ProjectHopes.border.raid and E.db.unitframe.units.raid1.enable then
            BORDER:CreateBorder(_G.ElvUF_Raid1, 20, -9, 9, 9, -9)

            local Raid1Background = CreateFrame("Frame", nil, _G.ElvUF_Raid1, BackdropTemplateMixin and "BackdropTemplate")
            Raid1Background:SetBackdrop(Private.BackgroundTexture)
            Raid1Background:SetFrameLevel(_G.ElvUF_Raid1:GetFrameLevel() + 1)
            Raid1Background:SetPoint("TOPLEFT", _G.ElvUF_Raid1, -2, 2)
            Raid1Background:SetPoint("BOTTOMRIGHT", _G.ElvUF_Raid1, 2, -2)
            Raid1Background:SetBackdropColor(0.1254901960784314, 0.1254901960784314, 0.1254901960784314)
            local Raid1BorderVSeparator = {}
            for i = 1, 5 do
                Raid1BorderVSeparator[i] = CreateFrame("Frame", nil, _G.ElvUF_Raid1, BackdropTemplateMixin and "BackdropTemplate")
                Raid1BorderVSeparator[i]:SetBackdrop(Private.vSeparator)
                Raid1BorderVSeparator[i]:SetWidth(16)
                Raid1BorderVSeparator[i]:SetFrameLevel(_G.ElvUF_Raid1:GetFrameLevel() + 22)
                Raid1BorderVSeparator[i]:SetPoint("TOPLEFT", _G["ElvUF_Raid1Group1UnitButton"..i], -4, 0)
                Raid1BorderVSeparator[i]:SetPoint("BOTTOMLEFT", _G.ElvUF_Raid1, 0, 0)
                Raid1BorderVSeparator[i]:Hide()
            end

            local Raid1BorderHSeparator = {}
            for i = 2, 8 do
                Raid1BorderHSeparator[i] = CreateFrame("Frame", nil, _G.ElvUF_Raid1, BackdropTemplateMixin and "BackdropTemplate")
                Raid1BorderHSeparator[i]:SetBackdrop(Private.Separator)
                Raid1BorderHSeparator[i]:SetHeight(16)
                Raid1BorderHSeparator[i]:SetFrameLevel(_G.ElvUF_Raid1:GetFrameLevel() + 21)
                Raid1BorderHSeparator[i]:SetPoint("TOPRIGHT", _G["ElvUF_Raid1Group"..i], 0, 4)
                Raid1BorderHSeparator[i]:SetPoint("LEFT", _G.ElvUF_Raid1, 0, 0)
                Raid1BorderHSeparator[i]:Hide()
            end

            local function UpdateRaid1Border()
                local members = GetNumGroupMembers()
                local maxSubgroup = 1
                for j = 1, members do
                    local name, rank, subgroup = GetRaidRosterInfo(j)
                    if subgroup > maxSubgroup then
                        maxSubgroup = subgroup
                    end
                end
                for i = 2, 8 do
                    if i <= maxSubgroup then
                        Raid1BorderHSeparator[i]:Show() 
                    else
                        Raid1BorderHSeparator[i]:Hide()
                    end
                end
                    
                for i = 1, 5 do
                    if i <= 4 then -- And this condition
                        Raid1BorderVSeparator[i]:Show()
                        Raid1BorderVSeparator[i]:SetPoint("BOTTOMLEFT", _G["ElvUF_Raid1Group"..maxSubgroup], 0, 0)
                    else
                        Raid1BorderVSeparator[i]:Hide()
                    end
                end
                
                local groupnum = "ElvUF_Raid1Group" .. maxSubgroup
                _G.ElvUF_Raid1.border:SetPoint("TOPLEFT", ElvUF_Raid1, -9, 9)
                _G.ElvUF_Raid1.border:SetPoint("TOPRIGHT", ElvUF_Raid1, 9, -9)
                _G.ElvUF_Raid1.border:SetPoint("BOTTOMRIGHT", groupnum, 9, -9)
                Raid1Background:SetPoint("TOPLEFT", ElvUF_Raid1, -3, 3)
                Raid1Background:SetPoint("TOPRIGHT", ElvUF_Raid1, 3, -3)
                Raid1Background:SetPoint("BOTTOMRIGHT", groupnum, 3, -3)	
            end

            local frame = CreateFrame("Frame")
            frame:RegisterEvent("GROUP_ROSTER_UPDATE")
            frame:SetScript("OnEvent", function(self, event, ...)
                    UpdateRaid1Border()
            end)
            frame:GetScript("OnEvent")(frame, "GROUP_ROSTER_UPDATE")
        end
        
        if E.db.ProjectHopes.border.raiddps and E.db.unitframe.units.raid1.enable then
            for k = 1, 8 do
                for l = 1, 5 do
                    local slots = {_G["ElvUF_Raid1Group"..k..'UnitButton'..l]}
                    for _, button in pairs(slots) do
                        if button and not button.border then
                            if button.db.power.enable then
                                if button.db.power.width == "spaced" then
                                    BORDER:CreateBorder(button.Health)

                                    BORDER:CreateBorder(button.Power)
                                elseif button.db.power.width == "offset" then
                                    BORDER:CreateBorder(button)

                                    if button.db.power.offset > 0 then
                                        if not button.Power.border then
                                            BORDER:CreateBorder(button.Power)
                                        end
                                    end
                                else
                                    BORDER:CreateBorder(button)
                                end
                            else
                                BORDER:CreateBorder(button, 22, -9, 9, 9, -9)
                            end
                        end
                    end
                end
            end
        end

        -- Player
        --[[
        if E.db.ProjectHopes.border.Player and E.db.unitframe.units.player.enable then
            local ElvUF_Player = _G.ElvUF_Player
            BorderAndSeparator(ElvUF_Player)
            if E.db.ProjectHopes.border.Playersep then
                if ElvUF_Player.Power.separator then
                    ElvUF_Player.Power.separator:Show()
                    ElvUF_Player.Power.separator:SetIgnoreParentAlpha(false)
                end
            else
                if ElvUF_Player.Power.separator then
                    ElvUF_Player.Power.separator:Hide()
                end
            end
        end]]

        -- Target
        if E.db.ProjectHopes.border.Target and E.db.unitframe.units.target.enable then
            local ElvUF_Target = _G.ElvUF_Target
            BorderAndSeparator(ElvUF_Target)
            if E.db.ProjectHopes.border.Targetsep then
                if ElvUF_Target.Power.separator then
                    ElvUF_Target.Power.separator:Show()
                    ElvUF_Target.Power.separator:SetIgnoreParentAlpha(false)
                end
            else
                if ElvUF_Target.Power.separator then
                    ElvUF_Target.Power.separator:Hide()
                end
            end
        end

        -- Focus
        if E.db.ProjectHopes.border.Focus and E.db.unitframe.units.focus.enable then
            local ElvUF_Focus = _G.ElvUF_Focus
            BorderAndSeparator(ElvUF_Focus)
        end

        -- Target of Target
        if E.db.ProjectHopes.border.TargetofTarget and E.db.unitframe.units.targettarget.enable then
            local ElvUF_TargetTarget = _G.ElvUF_TargetTarget
            BorderAndSeparator(ElvUF_TargetTarget)
        end

        -- Boss
        if E.db.ProjectHopes.border.Boss and E.db.unitframe.units.boss.enable then
            for i = 1, 8 do
                local ElvUF_Boss = _G["ElvUF_Boss"..i]
                BorderAndSeparator(ElvUF_Boss)
                if ElvUF_Boss.Power.separator then
                    ElvUF_Boss.Power.separator:SetIgnoreParentAlpha(false)
                end
                if ElvUF_Boss.border then
                    ElvUF_Boss.border:SetFrameLevel(22)
                    ElvUF_Boss.border:SetPoint("TOPLEFT", ElvUF_Boss, "TOPLEFT", -9, 9) 
                    ElvUF_Boss.border:SetPoint("BOTTOMRIGHT", ElvUF_Boss, "BOTTOMRIGHT", 9, -9) 
                end
            end
        end

        -- Arena
        if E.db.ProjectHopes.border.Arena and E.db.unitframe.units.arena.enable then
            for i = 1, 5 do
                local ElvUF_Arena = _G["ElvUF_Arena"..i]
                BorderAndSeparator(ElvUF_Arena)
            end
        end

        -- Pet
        if E.db.ProjectHopes.border.Pet and E.db.unitframe.units.pet.enable then
            local ElvUF_Pet = _G.ElvUF_Pet
            BorderAndSeparator(ElvUF_Pet)
        end

        -- Off tank / Main tank.
        if E.db.ProjectHopes.border.Maintankofftank and E.db.unitframe.units.tank.enable then
            for i = 1, 2 do 
                local ElvUF_TankUnitButton = _G["ElvUF_TankUnitButton"..i]
                BorderAndSeparator(ElvUF_TankUnitButton)
                if E.db.ProjectHopes.border.AssistUnits and E.db.unitframe.units.assist.enable then
                    local ElvUF_AssistUnitButton = _G["ElvUF_AssistUnitButton"..i]
                    BorderAndSeparator(ElvUF_AssistUnitButton)
                end
            end
        end
    end
end

function ProjectHopes:ElvUI_UnitFrames_PostUpdateAura(uf, _, button)
    if not E.db.ProjectHopes.border.AuraUF then
        return
    end

    if uf.isNameplate then
        return
    end

    if not button.IsBorder then
        BORDER:CreateBorder(button)
        BORDER:BindBorderColorWithBorder(button.border, button)
        button.IsBorder = true
    end
end

ProjectHopes:SecureHook(UF, "PostUpdateAura", "ElvUI_UnitFrames_PostUpdateAura")
