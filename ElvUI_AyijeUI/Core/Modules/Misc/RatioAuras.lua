local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI);
local RA = E:NewModule('RadioAuras', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local A = E.Auras

for _, auraType in next, {'buffs', 'debuffs'} do
	P.auras[auraType].keepSizeRatio = true
	P.auras[auraType].height = 18
end

local IS_HORIZONTAL_GROWTH = {
	RIGHT_DOWN = true,
	RIGHT_UP = true,
	LEFT_DOWN = true,
	LEFT_UP = true,
}

local DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER = {
	DOWN_RIGHT = -1,
	DOWN_LEFT = -1,
	UP_RIGHT = 1,
	UP_LEFT = 1,
	RIGHT_DOWN = -1,
	RIGHT_UP = 1,
	LEFT_DOWN = -1,
	LEFT_UP = 1,
}

local function UpdateIcon(_, button)
  local db = A.db[button.auraType]

  local pos = db.barPosition
  local iconSize = db.size - (E.Border * 2)
  local iconHeight = (db.keepSizeRatio and db.size or db.height) - (E.Border * 2)
  local isOnTop, isOnBottom = pos == 'TOP', pos == 'BOTTOM'
  local isHorizontal = isOnTop or isOnBottom

  button.statusBar:Size(isHorizontal and iconSize or (db.barSize + (E.PixelMode and 0 or 2)), isHorizontal and (db.barSize + (E.PixelMode and 0 or 2)) or iconHeight)

  local largerDimension = math.max(iconSize, iconHeight)
  button.texture:Size(largerDimension, largerDimension)

  button.texture:SetPoint("CENTER", button, "CENTER", 0, 0)

  local zoomFactor = 0.1
  if iconSize > iconHeight then
      local texCoord = (largerDimension - iconHeight) / largerDimension / 2
      button.texture:SetTexCoord(0 + zoomFactor, 1 - zoomFactor, texCoord + zoomFactor, 1 - texCoord - zoomFactor)
  else
      local texCoord = (largerDimension - iconSize) / largerDimension / 2
      button.texture:SetTexCoord(texCoord + zoomFactor, 1 - texCoord - zoomFactor, 0 + zoomFactor, 1 - zoomFactor)
  end
end

local function UpdateHeader(_, header)
	if not E.private.auras.enable then return end

	local db = A.db[header.auraType]

	local template = format('ElvUIAuraTemplate%d%d', db.size, (db.keepSizeRatio and db.size or db.height))

	if header.filter == 'HELPFUL' then
		header:SetAttribute('weaponTemplate', template)
	end

	header:SetAttribute('template', template)

	if IS_HORIZONTAL_GROWTH[db.growthDirection] then
		header:SetAttribute('minHeight', (db.verticalSpacing + (db.keepSizeRatio and db.size or db.height)) * db.maxWraps)
		header:SetAttribute('wrapYOffset', DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[db.growthDirection] * (db.verticalSpacing + (db.keepSizeRatio and db.size or db.height)))
	else
		header:SetAttribute('minHeight', ((db.wrapAfter == 1 and 0 or db.verticalSpacing) + (db.keepSizeRatio and db.size or db.height)) * db.wrapAfter)
		header:SetAttribute('yOffset', DIRECTION_TO_VERTICAL_SPACING_MULTIPLIER[db.growthDirection] * (db.verticalSpacing + (db.keepSizeRatio and db.size or db.height)))
	end

	local index = 1
	local child = select(index, header:GetChildren())
	while child do
		child:Size(db.size, db.keepSizeRatio and db.size or db.height)

		A:UpdateIcon(child)

		if index > (db.maxWraps * db.wrapAfter) and child:IsShown() then
			child:Hide()
		end

		index = index + 1
		child = select(index, header:GetChildren())
	end

end

local function Initialize()
	hooksecurefunc(A, 'UpdateHeader', UpdateHeader)
	hooksecurefunc(A, 'UpdateIcon', UpdateIcon)

end

hooksecurefunc(E, 'LoadAPI', Initialize)