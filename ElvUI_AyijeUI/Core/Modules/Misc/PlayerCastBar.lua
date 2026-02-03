local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local _G = _G

local CB = E:NewModule('Cast Bar', 'AceHook-3.0', 'AceEvent-3.0')
local BORDER = E:GetModule('BORDER')

-- Texture paths
local blizzcastback = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\blizzcastback.tga"
local blizzcast = [[UI-CastingBar-Filling-Standard]]
local blizzcastchannel = [[UI-CastingBar-Filling-Channel]]
local blizzcastnonbreakable = [[UI-CastingBar-Uninterruptable]]
local blizzinterrupt = [[UI-CastingBar-Interrupted]]
local sparkTexture = "4417031"

---------------------------------------------------
-- Fade Animation
---------------------------------------------------
local function FadeOut(self, isInterrupted)
    if self.isFading then return end

    self.isFading = true
    self.fadeStart = GetTime()
    
    -- Total time the bar exists after the event
    self.fadeDuration = isInterrupted and 0.4 or 0.2
    -- How long it stays fully opaque before starting to disappear
    self.holdDuration = isInterrupted and 0.2 or 0.0
    self.isInterrupted = isInterrupted

    if isInterrupted then
        self.txtObj:Hide()
        self.spellName:SetText("Interrupted")
    end
end

local function UpdateFade(self)
    if not self.isFading then return end

    local elapsed = GetTime() - self.fadeStart
    
    if elapsed >= self.fadeDuration then
        self:SetAlpha(0)
        self:Hide()
        self.isFading = false
        -- Reset for next cast
        self:SetAlpha(1)
        self.txtObj:Show()
        self.isInterrupted = false
        return
    end

    -- Stage 1: Hold at Alpha 1
    if elapsed <= self.holdDuration then
        self:SetAlpha(1)
    else
        -- Stage 2: Fade from Alpha 1 to 0 over the remaining time
        local fadeProgress = (elapsed - self.holdDuration) / (self.fadeDuration - self.holdDuration)
        self:SetAlpha(1 - fadeProgress)
    end
end

---------------------------------------------------
-- OnUpdate
---------------------------------------------------
local GetTime = _G.GetTime

local function OnUpdate(self)
    UpdateFade(self)
    -- Freeze the bar's progress while fading (Interrupt/Finish)
    if self.isFading then return end

    local now = GetTime()
    local endTime = self.curEndTime
    if not endTime then return end

    if now >= endTime then
        FadeOut(self, false)
        return
    end

    local totalDuration = endTime - self.curStartTime
    local displayValue = self.isReverse and (endTime - now) or (now - self.curStartTime)

    self.barObj:SetValue(displayValue)
    self.txtObj:SetFormattedText("%.1f", endTime - now)

    local sparkPos = (displayValue / totalDuration) * self.cachedWidth
    self.sparkObj:SetPoint("CENTER", self.topOverlay, "LEFT", sparkPos, 0)
end

---------------------------------------------------
-- Data Refresh
---------------------------------------------------
local function RefreshBarData(frame, isChannel)
    local name, text, _, startTime, endTime, _, _, notInterruptible

    if isChannel then
        name, text, _, startTime, endTime, _, notInterruptible = UnitChannelInfo("player")
    else
        name, text, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo("player")
    end

    if not name then return end

    frame.curStartTime = startTime / 1000
    frame.curEndTime = endTime / 1000
    frame.isReverse = isChannel
    frame.cachedWidth = frame:GetWidth()

    frame.barObj:SetMinMaxValues(0, frame.curEndTime - frame.curStartTime)

    if notInterruptible then
        frame.barObj:SetStatusBarTexture(blizzcastnonbreakable)
    elseif isChannel then
        frame.barObj:SetStatusBarTexture(blizzcastchannel)
    else
        frame.barObj:SetStatusBarTexture(blizzcast)
    end

    frame.spellName:SetText(text or name)
    frame.isFading = false
    frame:SetAlpha(1)
    frame:Show()
end

---------------------------------------------------
-- Frame Setup
---------------------------------------------------
function CB:CreateCastbar()
    if self.Castbar then return end

    local f = CreateFrame("Frame", "Ayije_Castbar", UIParent, "BackdropTemplate")
    f:Size(300, 20)
    f:SetPoint("CENTER", CastbarAnchor or UIParent, "CENTER", 0, 0)
    f:SetFrameStrata("MEDIUM")
    f:SetFrameLevel(10)

    f.bgTexture = f:CreateTexture(nil, "BACKGROUND")
    f.bgTexture:SetAllPoints()
    f.bgTexture:SetTexture(blizzcastback)

    f.castBar = CreateFrame("StatusBar", nil, f)
    f.castBar:SetAllPoints()
    f.castBar:SetStatusBarTexture(blizzcast)
    f.castBar:SetFrameLevel(11)
    f.barObj = f.castBar

    f.topOverlay = CreateFrame("Frame", nil, f)
    f.topOverlay:SetAllPoints()
    f.topOverlay:SetFrameLevel(50)

    local font, size, style = E.media.normFont, 15, E.db.general.fontStyle
    f.spellName = f.topOverlay:CreateFontString(nil, "OVERLAY")
    f.spellName:SetFont(font, size, style)
    f.spellName:SetPoint("LEFT", 4, 0)

    f.timeText = f.topOverlay:CreateFontString(nil, "OVERLAY")
    f.timeText:SetFont(font, size, style)
    f.timeText:SetPoint("RIGHT", -4, 0)
    f.txtObj = f.timeText

    f.spark = f.topOverlay:CreateTexture(nil, "ARTWORK")
    f.spark:SetTexture(sparkTexture)
    f.spark:SetSize(16, 42)
    f.spark:SetTexCoord(0.222168, 0.232422, 0.294434, 0.317383)
    f.spark:SetDesaturated(true)
    f.spark:SetVertexColor(1, 1, 1, 1)
    f.sparkObj = f.spark

    f.borderFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
    f.borderFrame:SetAllPoints()
    f.borderFrame:SetFrameLevel(12)
    if BORDER and BORDER.CreateBorder then
        BORDER:CreateBorder(f.borderFrame)
    end

    -- Events
    f:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "player")
    f:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")

    f:SetScript("OnEvent", function(frame, event, unit, castID)
        if unit ~= "player" then return end

        if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
            frame.currentCastID = castID
            RefreshBarData(frame, event == "UNIT_SPELLCAST_CHANNEL_START")

        elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
            if castID == frame.currentCastID and not frame.isFading then
                FadeOut(frame, false)
            end

        elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
            if castID ~= frame.currentCastID then return end

            frame.barObj:SetStatusBarTexture(blizzinterrupt)
            FadeOut(frame, true)

        elseif event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
            RefreshBarData(frame, event == "UNIT_SPELLCAST_CHANNEL_UPDATE")
        end
    end)

    f:SetScript("OnUpdate", OnUpdate)
    self.Castbar = f
    f:Hide()
end

function CB:Initialize()
    if not CastbarAnchor then
        CastbarAnchor = CreateFrame("Frame", "CastbarAnchor", E.UIParent, "BackdropTemplate")
        CastbarAnchor:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
        CastbarAnchor:SetSize(300, 20)
        if E.CreateMover then
            E:CreateMover(CastbarAnchor, "Ayije: Cast Bar", "CastbarMover")
        end
    end

    self:CreateCastbar()
end

E:RegisterModule(CB:GetName())