local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI);

local OS = E:NewModule('Overshields', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule("UnitFrames");

-- Generic function to set any healPrediction property
function OS:SetAllHealPredictionProperty(key, value)
    for unit, db in pairs(E.db.unitframe.units) do
        if db.healPrediction then
            db.healPrediction[key] = value
        end
    end
    UF:Update_AllFrames()
end


function OS:Initialize()
	if not E.db.AYIJE.unitframe.overshield then return end
		
	hooksecurefunc(UF, "UpdateHealComm", function(self, _, _, _, absorb, _, hasOverAbsorb, hasOverHealAbsorb, health, maxHealth)
		if self.absorbBar then
			self.absorbBar:SetStatusBarTexture(Private.AbsorbOverlay)
			
			-- Configure texture wrapping
			local texture = self.absorbBar:GetStatusBarTexture()
			if texture then
				texture:SetHorizTile(true)
				texture:SetVertTile(true)
				texture:SetTexCoord(0, 1, 0, 1)
				texture:SetBlendMode("BLEND")
			end
			
			-- Add glow texture overlay
			if not self.overAbsorbGlow then
				self.overAbsorbGlow = self.absorbBar:CreateTexture(nil, "OVERLAY")
				self.overAbsorbGlow:SetBlendMode("ADD")
				self.overAbsorbGlow:SetTexture(Private.AbsorbGlow)
				self.overAbsorbGlow:SetWidth(1)
			end
				
			-- Show/hide and position glow based on absorb amount
			if absorb and absorb > 0 then
				local statusBarTexture = self.absorbBar:GetStatusBarTexture()
				local isReversed = self.absorbBar:GetReverseFill()
				
				if statusBarTexture then
					-- Clear all points first
					self.overAbsorbGlow:ClearAllPoints()
					
					if isReversed then
						self.overAbsorbGlow:SetPoint("TOPRIGHT", statusBarTexture, "TOPLEFT", 0, 0)
						self.overAbsorbGlow:SetPoint("BOTTOMRIGHT", statusBarTexture, "BOTTOMLEFT", 0, 0)
					else
						self.overAbsorbGlow:SetPoint("TOPLEFT", statusBarTexture, "TOPRIGHT", 0, 0)
						self.overAbsorbGlow:SetPoint("BOTTOMLEFT", statusBarTexture, "BOTTOMRIGHT", 0, 0)
					end
						
					-- Set width after positioning
					self.overAbsorbGlow:SetWidth(1)
				end
				self.overAbsorbGlow:Show()
			else
				self.overAbsorbGlow:Hide()
			end
		end
	end)
end

E:RegisterModule(OS:GetName());