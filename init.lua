-- logging setup
-- view logs with console (open with menu bar)
-- https://www.hammerspoon.org/docs/hs.logger.html
local log = hs.logger.new("debug", "debug")
log.d("initializing...")

-- Hammerspoon Hello World
-- https://www.hammerspoon.org/go/
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	-- Hammerspoon alert
	hs.alert.show("Hello World!")

	-- macOS native notifications
	-- tho i dunno why it isnt working lol
	-- hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)

-- Custom Window Switcher
-- from https://www.reddit.com/r/hammerspoon/comments/rj92su/help_switch_focus_to_next_app_window_across_spaces/
-- from https://github.com/Porco-Rosso/PorcoSpoon

-- Alt-B is bound to the switcher dialog for all apps.
-- Alt-shift-B is bound to the switcher dialog for the current app.
-- Ctrl-alt-cmd + tab cycles to the previously focused app.
local switcher = require("switcher")

-- keybinds below launches/switches to the window of the app or cycles through its open windows if already focused
-- switcherfunc() cycles through all widows of the frontmost app.

--  function to either open apps or switch through them using switcher
function openswitch(name)
	return function()
		if hs.application.frontmostApplication():name() == name then
			switcherfunc()
		else
			hs.application.launchOrFocus(name)
		end
	end
end

hs.hotkey.bind("alt", "2", openswitch("Zen"))

-- note:
-- oddly, even for this "native" solution, only 1 zen window is available on load
-- only when i hv focused on the other zen window at least once, only then will it appear on the list
-- similar behavior with hs.window.filter

-- https://www.hammerspoon.org/docs/hs.window.switcher.html
switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
hs.hotkey.bind("alt", "tab", "Next window", function()
	switcher:next()
end)

hs.hotkey.bind("alt-shift", "tab", "Prev window", function()
	switcher:previous()
end)
