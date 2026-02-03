local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local NB = E:NewModule('Nameplate Borders', 'AceHook-3.0', 'AceEvent-3.0')
local BORDER = E:GetModule('BORDER')

---------------------------------------------------
-- Optimized Helper
---------------------------------------------------
local function GetOrCreateBorder(parent, isAura)
    if not parent or not BORDER or not BORDER.CreateBorder then return end

    if not parent.customBorder then
        local borderFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        borderFrame:SetAllPoints(parent)
        
        BORDER:CreateBorder(borderFrame)
        parent.customBorder = borderFrame
    end

    local visual = parent.customBorder.border
    if visual then
        if isAura then
            visual:SetBackdropBorderColor(1.0, 0.086, 0.329, 1)
        else
            visual:SetBackdropBorderColor(1, 1, 1, 1)
        end
    end

    parent.customBorder:SetFrameLevel(parent:GetFrameLevel() + 2)
    return parent.customBorder
end

---------------------------------------------------
-- Core Logic (No Loops)
---------------------------------------------------
function NB:ApplyBorders(plate)
    local unitFrame = plate and plate.unitFrame
    if not unitFrame then return end

    -- Health
    if unitFrame.Health then
        GetOrCreateBorder(unitFrame.Health, false)
    end

    -- Castbar
    local cb = unitFrame.Castbar or unitFrame.CastBar
    if cb then
        GetOrCreateBorder(cb, false)
        if cb.Icon then
            if not cb.Icon.holder then
                local holder = CreateFrame("Frame", nil, cb, "BackdropTemplate")
                --holder:SetSize(cb.Icon:GetSize() > 0 and cb.Icon:GetSize() or 20, cb.Icon:GetSize() > 0 and cb.Icon:GetSize() or 20)
                --holder:SetPoint("RIGHT", cb, "LEFT", -6, 0)
                local size = cb.Icon:GetSize()
                if size == 0 then size = 20 end 
                holder:SetSize(size, size)
                holder:SetPoint("RIGHT", cb, "LEFT", -6, 0)
                cb.Icon.holder = holder
            end
            
            local iconBorder = GetOrCreateBorder(cb.Icon.holder, false)
            if iconBorder then iconBorder:SetShown(cb.Icon:IsShown()) end
        end
    end
end

function NB:ProcessAuraButton(button)
    if not button or button.nbBordered then return end
    if GetOrCreateBorder(button, true) then
        button.nbBordered = true
        if button.count then button.count:SetDrawLayer("OVERLAY", 7) end
        if button.time then button.time:SetDrawLayer("OVERLAY", 7) end
    end
end

---------------------------------------------------
-- Direct Hooks (No Delays)
---------------------------------------------------
function NB:HookNameplates()
    local NP = E:GetModule('NamePlates')
    if not NP then return end

    -- Hook Health Update (Triggers when plate appears or health changes)
    self:SecureHook(NP, 'Update_Health', function(_, frame)
        if frame and frame.GetParent then self:ApplyBorders(frame:GetParent()) end
    end)

    -- Hook Castbar (Direct call, no delay)
    if NP.PostUpdate_Castbar then
        self:SecureHook(NP, 'PostUpdate_Castbar', function(_, plate)
            if plate and plate.GetParent then self:ApplyBorders(plate:GetParent()) end
        end)
    end

    -- Hook Aura Construction (Runs exactly once per button creation)
    if NP.Construct_AuraIcon then
        self:SecureHook(NP, 'Construct_AuraIcon', function(_, button)
            self:ProcessAuraButton(button)
        end)
    end
end

function NB:Initialize()
    if not BORDER then return end
    self:HookNameplates()
    
    -- Final "Startup" loop to catch plates already on screen
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        self:ApplyBorders(plate)
        local uf = plate.unitFrame
        if uf then
            if uf.Buffs then for i=1, #uf.Buffs do self:ProcessAuraButton(uf.Buffs[i]) end end
            if uf.Debuffs then for i=1, #uf.Debuffs do self:ProcessAuraButton(uf.Debuffs[i]) end end
        end
    end
end

E:RegisterModule(NB:GetName())