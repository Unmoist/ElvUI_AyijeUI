local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI);
local OS = E:NewModule('Overshields', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local EP = LibStub("LibElvUIPlugin-1.0");
local UF = E:GetModule("UnitFrames");

local absorbOverlays = {};

if not E.Retail then return end

local function updateAbsorbOverlayFrame(self, _, _, _, absorb, _, hasOverAbsorb, hasOverHealAbsorb, health, maxHealth)
	local frame = self.frame;
	local absorbOverlay,overAbsorbGlow = unpack(absorbOverlays[frame]);

	local cappedAbsorbSize = absorb > maxHealth and maxHealth or absorb;
	if(cappedAbsorbSize > 0 and hasOverAbsorb)then
		absorbOverlay:SetPoint("TOPRIGHT", frame.Health, "TOPRIGHT", 0, 0);
		absorbOverlay:SetPoint("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", 0, 0);

		local totalWidth, totalHeight = frame:GetSize();
		local barSize = (cappedAbsorbSize - (maxHealth - health)) / maxHealth * totalWidth;

		absorbOverlay:SetWidth(barSize);
		absorbOverlay:SetTexCoord(0, barSize / 32, 0, totalHeight / 32);

		absorbOverlay:Show();
		overAbsorbGlow:Show();
	else

		absorbOverlay:Hide();
		overAbsorbGlow:Hide();
	end
end

local function createAbsorbOverlayFrame(self, frame)

    local parentFrame = frame.Health;
    if not parentFrame then
        return
    end

    local absorbOverlay = parentFrame:CreateTexture(nil, "OVERLAY"); -- Specify overlay layer
    absorbOverlay:SetTexture(Engine.AbsorbOverlay, true, true);

    local overAbsorbGlow = parentFrame:CreateTexture(nil, "OVERLAY"); -- Specify overlay layer
		overAbsorbGlow:SetBlendMode("ADD")
		overAbsorbGlow:SetTexture(Engine.AbsorbGlow);
		overAbsorbGlow:SetPoint("TOPLEFT", absorbOverlay, 0)
    overAbsorbGlow:SetPoint("BOTTOMLEFT", absorbOverlay, 0)
    overAbsorbGlow:SetWidth(10)

    local frameData = {
        absorbOverlay,
        overAbsorbGlow,
    };

    absorbOverlays[frame] = frameData;
end

function OS:SetTexture_HealComm(module, obj, texture)
    local func = self.hooks[module].SetTexture_HealComm

	texture = Engine.AbsorbTexture
    return self.hooks[module].SetTexture_HealComm(module, obj, texture)
end

function OS:Initialize()
	if not E.db.AYIJE.unitframe.overshield then return end

	UF:SecureHook(UF,"Construct_HealComm", createAbsorbOverlayFrame);
	UF:SecureHook(UF,"UpdateHealComm", updateAbsorbOverlayFrame);

	self:RawHook(UF, "SetTexture_HealComm")
end

E:RegisterModule(OS:GetName());