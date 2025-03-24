local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local UF = E:GetModule("UnitFrames")
local GetTime = GetTime

local function BorderAndSeparator(f)
    if f then
        if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
            if f.border then
                f.border:Hide()
            end

            BORDER:CreateBorder(f.Health.backdrop)
        else
            if f.Health.border then
                f.Health.border:Hide()
            end

            BORDER:CreateBorder(f, 15)
        end

        if f.USE_POWERBAR and (f.border or f.Health.backdrop.border) then
            local border = f.Power.border
            local separator = f.Power.separator
            if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
                if not border then
                    BORDER:CreateBorder(f.Power.backdrop)
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

function S:ElvUI_UnitFrames(_, unit)
    local frameName = gsub(E:StringTitle(unit), 't(arget)', 'T%1')
    local frame = UF[unit]
    local enabled = UF.db.units[unit].enable

    -- Player
    if frameName == 'Player' and enabled then
        if E.db.AYIJE.border.Player then
            local PF = UF['player']
            BorderAndSeparator(PF)
            if E.db.AYIJE.border.Playersep then
                if PF.Power.separator then
                    PF.Power.separator:Show()
                    PF.Power.separator:SetIgnoreParentAlpha(false)
                end
            else
                if PF.Power.separator then
                    PF.Power.separator:Hide()
                end
            end
        end
    end

    -- Target
    if frameName == 'Target' and enabled then
        if E.db.AYIJE.border.Target then
            local TF = UF['target']
            BorderAndSeparator(TF)
            if E.db.AYIJE.border.Targetsep then
                if TF.Power.separator then
                    TF.Power.separator:Show()
                    TF.Power.separator:SetIgnoreParentAlpha(false)
                end
            else
                if TF.Power.separator then
                    TF.Power.separator:Hide()
                end
            end
        end
    end

    -- Target of Target
    if frameName == 'TargetTarget' and enabled then
        if E.db.AYIJE.border.TargetofTarget then
            local TTF = UF['targettarget']
            BorderAndSeparator(TTF)
        end
    end

    -- Focus
    if frameName == 'Focus' and enabled then
        if E.db.AYIJE.border.Focus then
            local FF = UF['focus']
            BorderAndSeparator(FF)
        end
    end

    -- Focus Target
    if frameName == 'FocusTarget' and enabled then
        if E.db.AYIJE.border.FocusTarget then
            local FTF = UF['focustarget']
            BorderAndSeparator(FTF)
        end
    end

    -- Pet
    if frameName == 'Pet' and enabled then
        if E.db.AYIJE.border.Pet then
            local PetFrame = UF['pet']
            BorderAndSeparator(PetFrame)
        end
    end

    -- Pet Target
    if frameName == 'PetTarget' and enabled then
        if E.db.AYIJE.border.PetTarget then
            local PettargetFrame = UF['pettarget']
            BorderAndSeparator(PettargetFrame)
        end
    end

    -- Target of Target of Target
    if frameName == 'TargetTargetTarget' and enabled then
        if E.db.AYIJE.border.TargetofTargetofTarget  then
            local TTTF = UF['targettargettarget']
            BorderAndSeparator(TTTF)
        end
    end
end

function S:ElvUI_UnitFramesGroup (_, group, numGroup)
	for i = 1, numGroup do
		local unit = group..i
		local frame = UF[unit]
		local enabled = UF.db.units[group].enable

        if unit == "boss"..i and enabled then
            if E.db.AYIJE.border.Boss and E.db.unitframe.units.boss.enable then
                local BF = _G["ElvUF_Boss"..i]
                BorderAndSeparator(BF)
                if BF.Power.separator then
                    BF.Power.separator:SetIgnoreParentAlpha(false)
                end
                if BF.border then
                    BF.border:SetFrameLevel(22)
                end
            end
        end

        if unit == "arena"..i and enabled then
            if E.db.AYIJE.border.Arena and E.db.unitframe.units.arena.enable then
                for i = 1, 5 do
                    local AF = _G["ElvUF_Arena"..i]
                    BorderAndSeparator(AF)
                end
            end
        end
    end
end

function S:ElvUI_UnitFramesGroupRaidParty(_, group, groupFilter, template, headerTemplate, skip)
	local db = UF.db.units[group]
	local Header = UF[group]

	local enable = db.enable
	local name, isRaidFrames = E:StringTitle(group), strmatch(group, '^raid(%d)') and true

    if name == "Tank" and enable and E.db.AYIJE.border.Maintankofftank then
        for i = 1, 2 do 
            local TankFrame = _G["ElvUF_TankUnitButton"..i]
            BorderAndSeparator(TankFrame)
        end
    end

    if name == "Assist" and enable and E.db.AYIJE.border.AssistUnits then
        for i = 1, 2 do 
            local AssistFrame = _G["ElvUF_AssistUnitButton"..i]
            BorderAndSeparator(AssistFrame)
        end
    end
end

function S:ElvUI_UnitFrames_PostUpdateAura(uf, _, button)
    if not E.db.AYIJE.border.AuraUF then
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
    
    if not button.lastColorUpdate or GetTime() - button.lastColorUpdate > 0.1 then
        local r, g, b, a = button.border:GetBackdropBorderColor()
        button.Count:SetTextColor(r, g, b, a)
        button.lastColorUpdate = GetTime()
    end
end

function S:ElvUI_UnitFrames_Configure_AuraBars(_, f)
	local auraBars = f.AuraBars
	local db = f.db
	if db.aurabar.enable then
		for _, statusBar in ipairs(auraBars) do
			S:ElvUI_UnitFrames_Construct_AuraBars(nil, statusBar)
		end
	end
end

function S:ElvUI_UnitFrames_Construct_AuraBars(_, f)

    f.icon:SetPoint("RIGHT", f, "LEFT", -9, 0)

    for _, child in next, { f:GetChildren() } do
        if not child.border then
            BORDER:CreateBorder(child)
        end
	end
end

function S:UnitFrames()
    -- Player, Target, Target of Target, Focus, Focus Target, Pet, Pet Target, Target of Target of Target. 
	S:SecureHook(UF, "CreateAndUpdateUF", "ElvUI_UnitFrames")
    
    -- Boss and Arena.
    S:SecureHook(UF, "CreateAndUpdateUFGroup", "ElvUI_UnitFramesGroup")

    -- Party and Raid.
    S:SecureHook(UF, "CreateAndUpdateHeaderGroup", "ElvUI_UnitFramesGroupRaidParty")

    --Aura's on Unitframes. 
    S:SecureHook(UF, "PostUpdateAura", "ElvUI_UnitFrames_PostUpdateAura")

    -- Status bar
	S:SecureHook(UF, "Configure_AuraBars", "ElvUI_UnitFrames_Configure_AuraBars")
	S:SecureHook(UF, "Construct_AuraBars", "ElvUI_UnitFrames_Construct_AuraBars")
end

S:AddCallback("UnitFrames")