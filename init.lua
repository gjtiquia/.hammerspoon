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

-- map Alt+C / Alt+V to Cmd+C / Cmd+V (make Alt act like Command for copy/paste)
hs.hotkey.bind("alt", "c", function()
    hs.eventtap.keyStroke({ "cmd" }, "c")
end)

hs.hotkey.bind("alt", "v", function()
    hs.eventtap.keyStroke({ "cmd" }, "v")
end)

-- add Alt+X (cut) and Alt+A (select all)
hs.hotkey.bind("alt", "x", function()
    hs.eventtap.keyStroke({ "cmd" }, "x")
end)

hs.hotkey.bind("alt", "a", function()
    hs.eventtap.keyStroke({ "cmd" }, "a")
end)

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

-- alt left/right split window (derived from Windows / Linux as well)
hs.hotkey.bind("alt", "left", function()
	local win = hs.window.focusedWindow()
	if win then
		local f = win:frame()
		local screen = win:screen()
		local max = screen:frame()

		f.x = max.x
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h
		win:setFrame(f)
	end
end)

hs.hotkey.bind("alt", "right", function()
	local win = hs.window.focusedWindow()
	if win then
		local f = win:frame()
		local screen = win:screen()
		local max = screen:frame()

		f.x = max.x + (max.w / 2)
		f.y = max.y
		f.w = max.w / 2
		f.h = max.h
		win:setFrame(f)
	end
end)

-- alt+down toggle between centered half-size and full screen
hs.hotkey.bind("alt", "down", function()
	local win = hs.window.focusedWindow()
	if win then
		local screen = win:screen()
		local max = screen:frame()
		-- half-size centered frame
		local half = {
			x = max.x + (max.w / 4),
			y = max.y + (max.h / 4),
			w = max.w / 2,
			h = max.h / 2,
		}
		local f = win:frame()
		-- check if current frame matches half-size (allow small difference)
        local diff = 4 -- 1 works but i want more allowance
		if
			math.abs(f.x - half.x) < diff
			and math.abs(f.y - half.y) < diff
			and math.abs(f.w - half.w) < diff
			and math.abs(f.h - half.h) < diff
		then
			-- currently half-size, go full screen
			win:setFrame(max)
		else
			-- otherwise set to half-size centered
			win:setFrame(half)
		end
	end
end)

-- show current date and time
hs.hotkey.bind("alt", "t", function()
	hs.alert.show(os.date("[ %Y-%m-%d | %H:%M:%S | %A %u ]"), { padding = 40, textFont = "FiraMonoNFM-Regular" })
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
