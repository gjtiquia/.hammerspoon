-- logging setup
-- view logs with console (open with menu bar)
-- https://www.hammerspoon.org/docs/hs.logger.html
local log = hs.logger.new('debug','debug')
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

-- Alt 2 = Browser
-- Raycast cant launch Zen Browser properly if its not launched yet
-- Raycast also cant cycle thru windows thru spaces
-- TODO : not working well tho, deleted all and left to barebones, should try Spoon plugins
hs.hotkey.bind({ "alt" }, "2", function()
	hs.application.launchOrFocus("Zen")
end)
