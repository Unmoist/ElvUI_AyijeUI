local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local A = E:GetModule("Auras")

local _G = _G

function S:ElvUI_Auras_SkinIcon(_, button)
	if not button.IsBorder then
		BORDER:CreateBorder(button)
		BORDER:BindBorderColorWithBorder(button.border, button)

		
		local function EnterMouse()
			button.highlight:Kill()
			button.border:SetBackdropBorderColor(1, .82, .25)
		end
		
		local function LeaveMouse()
			button.highlight:Kill()
			button.border:SetBackdropBorderColor(1, 1, 1)
		end

		button:HookScript('OnEnter', EnterMouse)
		button:HookScript('OnLeave', LeaveMouse)
		
		button.IsBorder = true
	end
end

function S:ElvUI_Auras()
	if not E.private.auras.enable or not E.db.AYIJE.border.Aura then
		return
	end

	S:SecureHook(A, "CreateIcon", "ElvUI_Auras_SkinIcon")
	S:SecureHook(A, "UpdateAura", "ElvUI_Auras_SkinIcon")
	S:SecureHook(A, "UpdateTempEnchant", "ElvUI_Auras_SkinIcon") 
end

S:AddCallback("ElvUI_Auras")
