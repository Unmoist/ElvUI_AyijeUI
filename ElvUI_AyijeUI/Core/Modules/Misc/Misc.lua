local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)

-- Add "Ayije_CreateBar(aura_env)" in "On Show"
-- Add "Ayije_EndBar(aura_env)" in "On Hide" 

function Ayije_CreateBar(aura_env)
  local bar = aura_env.region.bar
  local size = bar:GetHeight() + 16
  local barBorder = aura_env.region.barBorder
  
  if not barBorder then
      barBorder = CreateFrame("Frame", nil, bar, "BackdropTemplate") -- Create a new frame for the border
      aura_env.region.barBorder = barBorder
  end
  
  barBorder:SetSize(size, size) -- Set the size of the border
  barBorder:SetPoint("RIGHT", bar, "LEFT", 2, 0) -- Position the border to the left of the bar
  barBorder:SetBackdrop(Engine.Border) -- Set the backdrop of the border
  
  local iconTex = barBorder.icon or barBorder:CreateTexture(nil, "BACKGROUND", nil, -2) -- Create a new texture for the icon
  
  iconTex:SetPoint("TOPLEFT", barBorder, "TOPLEFT", 8, -8) -- Position the icon texture inside the border
  iconTex:SetPoint("BOTTOMRIGHT", barBorder, "BOTTOMRIGHT", -8, 8)
  
  local icon = aura_env.region.icon:GetTexture() -- Get the texture from the aura's icon
  iconTex:SetTexture(icon) -- Set the texture to the icon
  
  barBorder.icon = iconTex
end

function Ayije_EndBar(aura_env)
  local barBorder = aura_env.region.barBorder
  if barBorder then
      barBorder:Hide() -- Hide the border when the bar is hidden
      
      local iconTex = barBorder.icon
      if iconTex then
          iconTex:SetTexture(nil) -- Clear the icon texture
      end
      
      barBorder.icon = nil
      barBorder:ClearAllPoints() -- Clear all points for the border
      aura_env.region.barBorder = nil
  end
end
