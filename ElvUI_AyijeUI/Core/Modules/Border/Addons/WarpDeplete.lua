local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')

local _G = _G

local pairs = pairs

function S:ReskinWarpDepleteBars()
	local Warp  = _G.WarpDeplete
	local WarpBars = Warp.bars
	for _, barFrame in pairs(WarpBars) do
		local bar = barFrame.bar
		if not bar.Border then
			bar:SetTemplate("Transparent")
			BORDER:CreateBorder(bar, 1, -9, 8, 9, -8)
			bar.Border = true
		end
	end

	if not Warp.forces.bar.border then
		Warp.forces.bar:SetTemplate("Transparent")
		BORDER:CreateBorder(Warp.forces.bar, 1, -9, 8, 9, -8)
	end
end

function S:WarpDeplete()
	if not E.db.AYIJE.skins.warpdeplete then return end

	if not _G.WarpDeplete then
		return
	end

	if _G.WarpDeplete.bars then
		S:ReskinWarpDepleteBars()
	else
		S:SecureHook(
			_G.WarpDeplete,
			_G.WarpDeplete.InitDisplay and "InitDisplay" or "InitRender",
			"ReskinWarpDepleteBars"
		)
	end
end

S:AddCallbackForAddon("WarpDeplete")

