-- logging setup
-- view logs with console (open with menu bar)
-- https://www.hammerspoon.org/docs/hs.logger.html
local log = hs.logger.new("debug", "debug")
log.d("initializing...")

-- Hammerspoon Hello World
-- https://www.hammerspoon.org/go/
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.alert.show("Hello World!")
end)

-- Alt-B is bound to the switcher dialog for all apps.
-- Alt-shift-B is bound to the switcher dialog for the current app.
-- Ctrl-alt-cmd + tab cycles to the previously focused app.
local switcher = require("switcher")

--  function to either launch apps or switch through them using switcher
function openswitch(name)
	return function()
		if hs.application.frontmostApplication():name() == name then
            -- cycles through all windows of the frontmost app
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
-- similar behavior with hs.window.filter and the custom switcher

-- https://www.hammerspoon.org/docs/hs.window.switcher.html
switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
hs.hotkey.bind("alt", "tab", "Next window", function()
	switcher:next()
end)

hs.hotkey.bind("alt-shift", "tab", "Prev window", function()
	switcher:previous()
end)
