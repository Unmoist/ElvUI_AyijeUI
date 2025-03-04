local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule('UnitFrames')
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local CB = E:NewModule('Custombackdrop', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

function CB:Initialize()
	if IsAddOnLoaded("ElvUI") then
		if E.db.AYIJE.cbackdrop.Backdrop then
			hooksecurefunc(UF, "PostUpdateHealthColor", function(self, unit, r, g, b)
				if self.bg then
					self.bg:SetTexture(E.LSM:Fetch("statusbar", E.db.AYIJE.cbackdrop.customtexture))
				end
			end)
		end
	end
end

E:RegisterModule(CB:GetName());
