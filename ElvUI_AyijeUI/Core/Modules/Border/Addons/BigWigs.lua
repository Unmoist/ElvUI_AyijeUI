local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G
local format = format
local pairs = pairs
local tinsert = tinsert
local tremove = tremove
local unpack = unpack

local CreateFrame = CreateFrame
local nameplateIcons, iconFrameCache, nameplateTexts, textFrameCache = {}, {}, {}, {}

local pool = {
    spark = {}
}

local function removeStyle(bar)
    local bd = bar.candyBarBackdrop
    bd:Hide()
    if bd.iborder then
        bd.iborder:Hide()
        bd.oborder:Hide()
    end

    local tex = bar:Get("bigwigs:restoreicon")
    if tex then
        bar:SetIcon(tex)
        bar:Set("bigwigs:restoreicon", nil)

        local iconBd = bar.candyBarIconFrameBackdrop
        iconBd:Hide()
        if iconBd.iborder then
            iconBd.iborder:Hide()
            iconBd.oborder:Hide()
        end
    end

    local spark = bar:Get("bigwigs:ayijeui:spark")
    if spark then
        spark:Hide()
        table.insert(pool.spark, spark)
        bar:Set("bigwigs:ayijeui:spark", nil)
    end
end

local function styleBar(bar)
    local bd = bar.candyBarBackdrop

    -- Apply backdrop to the bar with custom border
    bd:SetBackdrop(Engine.Border)
    bd:SetBackdropColor(0.00, 0.00, 0.00, 0)
    bd:SetBackdropBorderColor(1, 1, 1)

    bd:ClearAllPoints()
    bd:SetFrameLevel(bar:GetFrameLevel() + 2)
    bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -8, 8)
    bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 8, -8)
    bd:Show()
        

    local spark = bar.candyBarBar:CreateTexture(nil, "ARTWORK", nil)
    spark:SetTexture(Engine.Glowline)
    spark:SetBlendMode("ADD")

    local height = bar:GetHeight()
    spark:SetSize(10, height)  -- Adjusted size based on the height of the frame
    spark:SetPoint("CENTER", bar.candyBarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
    spark.windPoolType = "spark"
    spark:Show()
    bar:Set("bigwigs:ayijeui:spark", spark)

    local tex = bar:GetIcon()
    if tex then
        local icon = bar.candyBarIconFrame
        bar:SetIcon(nil)
        icon:SetTexture(tex)
        icon:Show()

        -- Offset the icon to the left of the bar
        icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -6, 0)
        icon:SetSize(height, height)
        bar:Set("bigwigs:restoreicon", tex)

        local iconBd = bar.candyBarIconFrameBackdrop

        -- Apply the same backdrop to the icon frame with custom border
        iconBd:SetBackdrop(Engine.Border)
        iconBd:SetBackdropColor(0.00, 0.00, 0.00, 0)
        iconBd:SetBackdropBorderColor(1, 1, 1)

        iconBd:ClearAllPoints()
        iconBd:SetFrameLevel(bar:GetFrameLevel() + 2)
        iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -8, 8)
        iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 8, -8)
        iconBd:Show()
    end
end

function S:BigWigs_Plugins()
	if not _G.BigWigs or not _G.BigWigsAPI then
		return
	end


	BigWigsAPI:RegisterBarStyle("AyijeUI", {
		apiVersion = 1,
		version = 1,
		barSpacing = 6,
		barHeight = 32,
        fontSizeNormal = 16,
		fontSizeEmphasized = 16,
		fontOutline = "OUTLINE",
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		OnBarCreate = adjustBarPosition, -- Called when a new bar is created
		GetStyleName = function() return "Ayijeui" end,
	})
end

function S:BigWigs_QueueTimer()
	if not E.db.AYIJE.skins.bigwigsqueue then return end

	local spark = true  -- Define spark here

	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterMessage(
			"ElvUI_AyijeUI",
			"BigWigs_FrameCreated",
			function(_, frame, name)
				if name == "QueueTimer" then
					local parent = frame:GetParent()
					frame:StripTextures()
					frame:CreateBackdrop("Transparent")
					BORDER:CreateBorder(frame.backdrop)

					E:SetSmoothing(frame)

					local statusBarTexture = frame:GetStatusBarTexture()

					statusBarTexture:SetTexture(Engine.Ayije_light)
					statusBarTexture:SetVertexColor(1, 0.776, 0.027)

					if spark then
						frame.spark = frame:CreateTexture(nil, "ARTWORK", nil, 1)
						frame.spark:SetTexture(Engine.Glowline)
						frame.spark:SetBlendMode("ADD")
					end

					frame:SetSize(parent:GetWidth(), 10)
					frame:SetHeight(18)
					frame:ClearAllPoints()
					frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 1, -7)
					frame:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", -1, -7)
					frame.text.SetFormattedText = function(self, _, time)
						self:SetText(format("%d", time))

						if spark then
							local min, max = frame:GetMinMaxValues()
							local value = frame:GetValue()
							local sparkPosition = (value / max) * frame:GetWidth()
							frame.spark:SetPoint("CENTER", frame, "LEFT", sparkPosition, 0)
							frame.spark:SetSize(10, frame:GetHeight())

						end
					end
					frame.text:ClearAllPoints()
					frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)

					local fontPath = [[Interface\AddOns\ElvUI_AyijeUI\Media\Fonts\Expressway.ttf]]
					frame.text:SetFont(fontPath, 16, 'OUTLINE')
					
				end
			end
		)
	end
end

S:AddCallbackForAddon("BigWigs_Plugins")
S:AddCallback("BigWigs_QueueTimer")