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
hs.hotkey.bind({ "alt" }, "2", function()
	local appName = "Zen"

	local app = hs.application.get(appName)

	-- If app is not running, launch it
	if not app then
		hs.application.launchOrFocus(appName)
		return
	end

	-- Use only normal windows
	local windows = hs.fnutils.filter(app:allWindows(), function(w)
		return w:isStandard()
	end)

	-- If no normal windows, bring app forward (or create one)
	if #windows == 0 then
		hs.application.launchOrFocus(appName)
		return
	end

	-- If exactly one, focus it
	if #windows == 1 then
		windows[1]:focus()
		return
	end

	-- If multiple, cycle to next window
	local current = hs.window.frontmostWindow()
	local currentIndex = 0
	if current then
		for i, w in ipairs(windows) do
			if w:id() == current:id() then
				currentIndex = i
				break
			end
		end
	end

	local nextIndex = (currentIndex % #windows) + 1
	windows[nextIndex]:focus()
end)
