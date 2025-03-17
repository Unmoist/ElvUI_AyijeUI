local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI);
local UGL = E:NewModule('UnitFramesGlowline', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local EP = LibStub("LibElvUIPlugin-1.0");
local UF = E:GetModule("UnitFrames");

local function UpdateGlowLinePosition(healthBar)
    if not healthBar.glowLine then return end

    local currentHealth = healthBar:GetValue()
    local maxHealth = select(2, healthBar:GetMinMaxValues())
    local healthPercentage = currentHealth / maxHealth

    local height = healthBar:GetHeight()
    local width = E.db.ProjectHopes.unitframe.unitFramesGlowlineWidth
    healthBar.glowLine:SetSize(width, height)

    if healthPercentage == 0 or healthPercentage == 1 then
        healthBar.glowLine:Hide()
    else
        healthBar.glowLine:Show()
        healthBar.glowLine:SetPoint("LEFT", healthBar, "LEFT", healthBar:GetWidth() * healthPercentage - 5, 0)
    end
end

local function CreateGlowLine(frame)
    if not frame.glowLine then
        frame.glowLine = frame:CreateTexture(nil, "OVERLAY")
        frame.glowLine:SetTexture(Engine.Glowline);
        frame.glowLine:SetBlendMode("ADD")
    end

    frame:HookScript("OnValueChanged", UpdateGlowLinePosition)
end

function UGL:ElvUI_UnitFrames_Health_GlowLine(_, f)
    CreateGlowLine(f.Health)
end

function UGL:Initialize()
    if not E.db.AYIJE.unitframe.unitFramesGlowline then return end
    
    UGL:SecureHook(UF, "UpdateNameSettings", "ElvUI_UnitFrames_Health_GlowLine")

end

E:RegisterModule(UGL:GetName());