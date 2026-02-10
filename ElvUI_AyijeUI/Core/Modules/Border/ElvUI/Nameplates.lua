local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local NP = E:GetModule('NamePlates')

function S:ElvUI_Nameplates_StylePlate(_, nameplate)
    if not E.db.AYIJE.border.nameplates then return end

    if nameplate.Health then
        if nameplate.Health.backdrop and not nameplate.Health.backdrop.border then
            BORDER:CreateBorder(nameplate.Health.backdrop, 3)
        end
    end

    if nameplate.Castbar then
        if nameplate.Castbar.backdrop and not nameplate.Castbar.backdrop.border then
            BORDER:CreateBorder(nameplate.Castbar.backdrop)
        end

        if nameplate.Castbar.Icon and not nameplate.Castbar.Icon.border then
            BORDER:CreateBorder(nameplate.Castbar.Icon)
        end
    end

    if nameplate.Power then
        if nameplate.Power.backdrop and not nameplate.Power.backdrop.border then
            BORDER:CreateBorder(nameplate.Power.backdrop, 3)
        end
    end

end

S:SecureHook(NP, "StylePlate", "ElvUI_Nameplates_StylePlate") -- Bordering all the elements for nameplate. 

function S:ElvUI_Nameplates_Construct_AuraIcon(_, button)
   if not E.db.AYIJE.border.nameplates then
        return
  end

	if not button then return end
	if button and not button.border then
        BORDER:CreateBorder(button, 3)
        BORDER:BindBorderColorWithBorder(button.border, button)
	end
end

S:SecureHook(NP, 'Construct_AuraIcon', "ElvUI_Nameplates_Construct_AuraIcon") -- Buffs and Debuffs.

function S:ElvUI_Nameplates_Update_Castbar(_, nameplate)
    if not E.db.AYIJE.border.nameplates then return end

    local element = nameplate.Castbar
    local child = element and select(1, element:GetChildren())

    if not element.glowLine then
        local glow = element:CreateTexture(nil, "OVERLAY")
        glow:SetTexture(Engine.Glowline)
        glow:SetBlendMode("BLEND")
        glow:SetVertexColor(1, 1, 1, 1)
        element.glowLine = glow
    end

    element.glowLine:ClearAllPoints()
    element.glowLine:SetPoint("LEFT", element:GetStatusBarTexture(), "RIGHT", -5, 0)
    element.glowLine:SetSize(6, element:GetHeight())
end

S:SecureHook(NP, "Update_Castbar", "ElvUI_Nameplates_Update_Castbar") -- Glowline for Castbar. 

