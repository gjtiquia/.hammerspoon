-- custom switcher
switcher = require("switcher")

hs.hotkey.bind("alt", "b", selectAnyOtherWindow)
hs.hotkey.bind({ "alt", "shift" }, "b", selectAnyWindowOfCurrentApp)

hs.hotkey.bind("alt", "2", openswitch("Zen"))

function listWindowsWithAppName(targetAppName)
	local windowChoices = {}
	for i, w in ipairs(switcher.currentWindows) do
		local app = w:application()
		local appImage = nil
		local appName = "(none)"

		if app then
			appName = app:name()
			appImage = hs.image.imageFromAppBundle(w:application():bundleID())
		end

		if appName ~= targetAppName then
			goto continue
		end

		-- print(w:title())
		-- print(appName)
		-- print(i)
		-- print(appImage)
		-- print("-------------------------")

		table.insert(windowChoices, {
			text = w:title() .. "--" .. appName,
			subText = appName,
			uuid = i,
			image = appImage,
			win = w,
		})

		::continue::
	end

	return windowChoices
end

function switchUnityEditor()

	local windows = listWindowsWithAppName("Unity")
	-- print(#windows)

	if #windows == 0 then
		hs.application.launchOrFocus("Unity Hub")
	end

	local choiceIndex = #windows -- use the last index as the choice index
	local window = windows[choiceIndex]["win"]
	if window then
		window:focus()
	end
end

hs.hotkey.bind("alt", "9", switchUnityEditor)

-- note:
-- oddly, even for this "native" solution, only 1 zen window is available on load
-- only when i hv focused on the other zen window at least once, only then will it appear on the list
-- similar behavior with hs.window.filter and the custom switcher alt+b (custom switcher did mention the hammerspoon window tracking is broken)
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
local nextWindow = hs.window.switcher.nextWindow
hs.hotkey.bind("alt", "tab", nextWindow, nil, nextWindow)
