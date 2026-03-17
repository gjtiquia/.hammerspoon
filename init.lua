-- custom switcher
require("switcher")

hs.hotkey.bind("alt", "b", selectAnyOtherWindow)
hs.hotkey.bind({ "alt", "shift" }, "b", selectAnyWindowOfCurrentApp)

hs.hotkey.bind("alt", "2", function()
	openswitch("Zen")
end)

hs.hotkey.bind("alt", "9", function()
	switchWithOpenFallback("Unity", "UnityHub")
end)

-- note:
-- oddly, even for this "native" solution, only 1 zen window is available on load
-- only when i hv focused on the other zen window at least once, only then will it appear on the list
-- similar behavior with hs.window.filter and the custom switcher alt+b (custom switcher did mention the hammerspoon window tracking is broken)
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
local nextWindow = hs.window.switcher.nextWindow
hs.hotkey.bind("alt", "tab", nextWindow, nil, nextWindow)
