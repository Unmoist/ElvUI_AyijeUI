local E, _, V, P, G = unpack(ElvUI)
local AddonName, Engine = ...

local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale)
local EP = LibStub('LibElvUIPlugin-1.0')
local PI = E:GetModule('PluginInstaller')

local tonumber = tonumber
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

AYIJE = E:NewModule(AddonName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
_G[AddonName] = Engine

Engine.Config = {}
Engine.Credits = {}

Engine.Logo = 'Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\phlogotiny.tga'
Engine.Name = E:TextGradient('AyijeUI', 0.6, 0.6, 0.6, 1, 0.78, 0.03)
Engine.Texture = 'Ayije_light'
Engine.RequiredElvUI = tonumber(GetAddOnMetadata(AddonName, 'X-Required-ElvUI'))
Engine.Version = tonumber(GetAddOnMetadata(AddonName, 'Version'))

Engine.Border = {bgFile = nil, edgeFile = "Interface\\Addons\\ElvUI_AyijeUI\\Media\\Borders\\Ayije_Thin.tga", tileSize = 0, edgeSize = 16, insets = {left = 8, right = 8, top = 8, bottom = 8}}
Engine.BorderLight = {bgFile = nil, edgeFile = "Interface\\Addons\\ElvUI_AyijeUI\\Media\\Borders\\Ayije_Empty.tga", tileSize = 0, edgeSize = 16, insets = {left = 8, right = 8, top = 8, bottom = 8}}
Engine.MinimapRectangle = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Rectangle.tga"
Engine.Portrait = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\CircleMaskScalable.tga"
Engine.PortraitBorder = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\portraitborder.tga"
Engine.Font = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Fonts\\Expressway.ttf"
Engine.Ayije_light = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\Ayije_light.tga"
Engine.Glowline = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Glowline.tga"
Engine.BackgroundTexture = {bgFile = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Square_White.tga", edgeFile = nil, tileSize = 0, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0}}
Engine.Separator = {bgFile = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Separator.tga", edgeFile = nil, tileSize = 0, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0}}
Engine.AbsorbOverlay = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Shield-Overlay.blp"
Engine.AbsorbGlow = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Shield-Overshield.blp"
Engine.AbsorbTexture = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Shield-Fill.tga"

----------------------------------------------------------------------
------------------------------- Events -------------------------------
----------------------------------------------------------------------

local E, _, V, P, G = unpack(ElvUI)
local AddonName, Engine = ...

local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale)
local EP = LibStub('LibElvUIPlugin-1.0')
local PI = E:GetModule('PluginInstaller')

local tonumber = tonumber
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

AYIJE = E:NewModule(AddonName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
_G[AddonName] = Engine

Engine.Config = {}
Engine.Credits = {}

Engine.Logo = 'Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\phlogotiny.tga'
Engine.Name = E:TextGradient('AyijeUI', 0.6, 0.6, 0.6, 1, 0.78, 0.03)
Engine.Texture = 'Ayije_light'
Engine.RequiredElvUI = tonumber(GetAddOnMetadata(AddonName, 'X-Required-ElvUI'))
Engine.Version = tonumber(GetAddOnMetadata(AddonName, 'Version'))

Engine.Border = {bgFile = nil, edgeFile = "Interface\\Addons\\ElvUI_AyijeUI\\Media\\Borders\\Ayije_Thin.tga", tileSize = 0, edgeSize = 16, insets = {left = 8, right = 8, top = 8, bottom = 8}}
Engine.BorderLight = {bgFile = nil, edgeFile = "Interface\\Addons\\ElvUI_AyijeUI\\Media\\Borders\\Ayije_Empty.tga", tileSize = 0, edgeSize = 16, insets = {left = 8, right = 8, top = 8, bottom = 8}}
Engine.MinimapRectangle = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Rectangle.tga"
Engine.Portrait = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\CircleMaskScalable.tga"
Engine.PortraitBorder = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\portraitborder.tga"
Engine.Font = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Fonts\\Expressway.ttf"
Engine.Ayije_light = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Statusbar\\Ayije_light.tga"
Engine.Glowline = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Glowline.tga"
Engine.BackgroundTexture = {bgFile = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Square_White.tga", edgeFile = nil, tileSize = 0, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0}}
Engine.Separator = {bgFile = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Separator.tga", edgeFile = nil, tileSize = 0, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0}}
Engine.AbsorbOverlay = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Shield-Overlay.blp"
Engine.AbsorbGlow = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Shield-Overshield.blp"
Engine.AbsorbTexture = "Interface\\AddOns\\ElvUI_AyijeUI\\Media\\Textures\\Shield-Fill.tga"

----------------------------------------------------------------------
------------------------------- Events -------------------------------
----------------------------------------------------------------------

local function Initialize()
    EP:RegisterPlugin(AddonName, AYIJE.Config)

    if E.data.profiles['AyijeUI'] then
        if E.private.AYIJE.profileSet == nil then
            AYIJE:Notification("Do you wish to load AyijeUI ElvUI profile onto this character?", function() AYIJE:LoadProfile() end, function() E.private.AYIJE.profileSet = Engine.Version end)
        end
    else
        Engine:Print("AyijeUI Profile don't exist, please import it from WAGO.")
    end
end

local function CallbackInitialize()
	Initialize()
end

E:RegisterModule(AddonName, CallbackInitialize)

local function CallbackInitialize()
	Initialize()
end

E:RegisterModule(AddonName, CallbackInitialize)