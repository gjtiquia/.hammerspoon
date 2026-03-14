-- Hammerspoon Hello World
-- https://www.hammerspoon.org/go/
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	-- Hammerspoon alert
	hs.alert.show("Hello World!")

	-- macOS native notifications
    -- tho i dunno why it isnt working lol
	-- hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)


