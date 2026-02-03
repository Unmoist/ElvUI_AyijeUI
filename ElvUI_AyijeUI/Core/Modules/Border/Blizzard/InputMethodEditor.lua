local AddonName, Engine = ...
local E, L, V, P, G = unpack(ElvUI)
local BORDER = E:GetModule('BORDER')

local S = E:GetModule('Skins')
local CH = E:GetModule('Chat')

local _G = _G
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local GetChannelName = GetChannelName

local function TestPrint()
	print("test")
end

function S:InputMethodEditor()

	for i = 1, NUM_CHAT_WINDOWS do
		local editBox = _G["ChatFrame" .. i .. "EditBox"]
		local langIcon = _G["ChatFrame" .. i .. "EditBoxLanguage"]

		if editBox then
		--	BORDER:CreateBorder(editBox)
			if langIcon then
				langIcon:StripTextures()
				langIcon:CreateBackdrop("Transparent")
				langIcon:Size(20, 22)
				langIcon:ClearAllPoints()
				langIcon:Point("TOPLEFT", editBox, "TOPRIGHT", 7, 0)
				BORDER:CreateBorder(langIcon)
			end
		end
	end

	E:Delay(1, function()
			S:RawHook(CH, "ChatEdit_UpdateHeader", function(self, editbox)
					-- Call original function
					S.hooks[CH]["ChatEdit_UpdateHeader"](self, editbox)
					
					-- Now override the colors after original finishes
					if editbox and editbox.SetBackdropBorderColor then
							editbox:SetBackdropBorderColor(1, 1, 1, 0)
							editbox:SetBackdropColor(1, 1, 1, 0)
					end
			end, true)
	end)

	if E.db.chat.panelBackdrop == "LEFT" then
		BORDER:CreateBorder(_G.LeftChatPanel)
	end


	local IMECandidatesFrame = _G.IMECandidatesFrame
	if not IMECandidatesFrame then
		return
	end

	IMECandidatesFrame:StripTextures()
	IMECandidatesFrame:SetTemplate()
	BORDER:CreateBorder(IMECandidatesFrame)

	for i = 1, 10 do
		local cf = IMECandidatesFrame["c" .. i]
		if cf then
			cf.candidate:Width(1000)
		end
	end
end

S:AddCallback("InputMethodEditor")