-- custom switcher
require("switcher")

-- keybindings are designed such that they match Linux/Windows keybindings as closely as possible, such that all operating systems can "share" keybindings

hs.hotkey.bind("alt", "1", function()
	hs.application.launchOrFocus("Ghostty")
end)

hs.hotkey.bind("alt", "2", function()
	-- launch/focus or switch between open windows
	openswitch("Zen")
end)

hs.hotkey.bind("alt", "3", function()
	hs.application.launchOrFocus("Obsidian")
end)

hs.hotkey.bind("alt", "4", function()
	hs.application.launchOrFocus("WhatsApp")
end)

hs.hotkey.bind("alt", "5", function()
	hs.application.launchOrFocus("Signal")
end)

hs.hotkey.bind("alt", "6", function()
	hs.application.launchOrFocus("Fork")
end)

hs.hotkey.bind("alt", "7", function()
	-- launch/focus or switch between open windows
	openswitch("Google Chrome")
end)

hs.hotkey.bind("alt", "8", function()
	hs.application.launchOrFocus("Unity Hub")
end)

hs.hotkey.bind("alt", "9", function()
	switchWithOpenFallback("Unity", "Unity Hub")
end)

-- this does not work too well, suggested to use native macOS keyboard shortcut in System Settings > Keyboard > Keyboard Shortcuts > Mission Control > Switch to Desktop 1
-- hs.hotkey.bind("alt", "0", function()
--     hs.spaces.gotoSpace(1)
-- end)

-- a keybinding originally derived from the custom switcher
hs.hotkey.bind("alt", "b", selectAnyOtherWindow)
hs.hotkey.bind({ "alt", "shift" }, "b", selectAnyWindowOfCurrentApp)

-- derived from Windows screencapture shortcut
hs.hotkey.bind({ "alt", "shift" }, "s", function()
	hs.application.launchOrFocus("Screenshot")
end)

-- derived from Windows / Linux fullscreen toggle
hs.hotkey.bind("alt", "up", function()
	local win = hs.window.focusedWindow()
	if win then
		win:toggleFullScreen()
	end
end)

-- note:
-- oddly, even for this "native" solution, only 1 zen window is available on load
-- only when i hv focused on the other zen window at least once, only then will it appear on the list
-- similar behavior with hs.window.filter and the custom switcher alt+b (custom switcher did mention the hammerspoon window tracking is broken)
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
local nextWindow = hs.window.switcher.nextWindow
hs.hotkey.bind("alt", "tab", nextWindow, nil, nextWindow)
