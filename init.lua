-- LSP config (and .luarc.json)
-- troubleshooting: try reloading config
-- https://www.hammerspoon.org/Spoons/EmmyLua.html
hs.loadSpoon("EmmyLua")

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

-- TODO : alt left/right split window

-- show current date and time
hs.hotkey.bind("alt", "t", function()
	hs.alert.show(os.date("[    %Y-%m-%d    |    %H:%M:%S    |    %A    ]"), { padding = 40 })
end)

-- alt+tab to switch to the last focused app (like cmd+tab)
-- getWindows() returns windows sorted by most-recently-focused by default
hs.hotkey.bind("alt", "tab", function()
	local currentApp = hs.application.frontmostApplication():name()
	local windows = hs.window.filter.default:getWindows()
	for _, win in ipairs(windows) do
		if win:application():name() ~= currentApp then
			win:focus()
			return
		end
	end
end)
