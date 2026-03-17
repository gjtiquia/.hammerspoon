-- custom switcher
require("switcher")

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

hs.hotkey.bind("alt", "b", selectAnyOtherWindow)
hs.hotkey.bind({ "alt", "shift" }, "b", selectAnyWindowOfCurrentApp)

-- note:
-- oddly, even for this "native" solution, only 1 zen window is available on load
-- only when i hv focused on the other zen window at least once, only then will it appear on the list
-- similar behavior with hs.window.filter and the custom switcher alt+b (custom switcher did mention the hammerspoon window tracking is broken)
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
local nextWindow = hs.window.switcher.nextWindow
hs.hotkey.bind("alt", "tab", nextWindow, nil, nextWindow)
