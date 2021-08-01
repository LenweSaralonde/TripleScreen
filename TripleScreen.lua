--- Play WoW on 3 monitors
-- @module TripleScreen

TripleScreen = {}

local MONITORS = 3

local SetCVar = C_CVar and C_CVar.SetCVar or SetCVar

--- Main initialization
--
function TripleScreen.Init()
	-- Force resolution to "auto"
	if GetCVar('gxFullscreenResolution') ~= 'auto' then
		SetCVar('gxFullscreenResolution', 'auto')
		UpdateWindow()
		print("[TripleScreen] Graphics resolution set to AUTO. Please restart AHK script.")
	end
end

--- Fix UI size and position, if needed
--
function TripleScreen.FixUIPosition()
	local monitorAspectRatio = GetMonitorAspectRatio()
	local windowWidth, windowHeight = GetPhysicalScreenSize()
	local monitorWidth, monitorHeight = floor(windowHeight * GetMonitorAspectRatio()), windowHeight
	local monitorCount = floor(windowWidth / monitorWidth)

	-- Center UI on the middle screen if we are in a 3 monitor configuration
	if windowWidth > monitorWidth and monitorCount >= MONITORS then
		-- Desired UI width
		local uiWidth = GetScreenWidth() / monitorCount

		-- UI needs to be resized
		if floor(UIParent:GetWidth() * 100) > floor(uiWidth * 100) then
			local uiLeft = uiWidth
			local uiRight = -uiWidth

			-- Clear chat positioning
			DEFAULT_CHAT_FRAME:ClearAllPoints()

			-- Resize UIParent
			UIParent:SetPoint('TOPLEFT', uiLeft, 0)
			UIParent:SetPoint('BOTTOMRIGHT', uiRight, 0)

			-- Refresh UI positions
			MainMenuBar:Hide()
			MainMenuBar:Show()
		end
	end
end

--- Create frame
--
TripleScreen.frame = CreateFrame('Frame')
TripleScreen.frame:RegisterEvent('PLAYER_LOGIN')
TripleScreen.frame:RegisterEvent('PLAYER_ENTERING_WORLD')
TripleScreen.frame:SetScript("OnEvent", function(self, event, ...)
	-- No need to activate if the computer has less than the required amount of monitors
	if GetMonitorCount() >= MONITORS then
		if event == 'PLAYER_LOGIN' then
			TripleScreen.Init()
		elseif event == 'PLAYER_ENTERING_WORLD' then
			TripleScreen.FixUIPosition()
			C_Timer.NewTicker(1, TripleScreen.FixUIPosition)
		end
	end
end)