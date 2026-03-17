-- custom switcher
switcher = require("switcher")

hs.hotkey.bind("alt", "b", selectAnyOtherWindow)
hs.hotkey.bind({ "alt", "shift" }, "b", selectAnyWindowOfCurrentApp)

hs.hotkey.bind("alt", "2", openswitch("Zen"))

function listWindows()
	local windowChoices = {}
	for i, w in ipairs(switcher.currentWindows) do
		local app = w:application()
		local appImage = nil
		local appName = "(none)"

		if app then
			appName = app:name()
			appImage = hs.image.imageFromAppBundle(w:application():bundleID())
		end

		print(w:title())
		print(appName)
		print(i)
		print(appImage)
        print("-------------------------")

		table.insert(windowChoices, {
			text = w:title() .. "--" .. appName,
			subText = appName,
			uuid = i,
			image = appImage,
			win = w,
		})
	end

	return windowChoices
end

function switchUnityEditor()
	print("switchUnityEditor")

	local windows = listWindows()
end

-- TODO : dont launch if there is no existing Unity editor, should launch Unity Hub
-- TODO : this works for one unity window, when two is open, it cant switch between
-- TODO : also it cycles between windows in one unity editor, where i want to cycle between different unity editors
-- TODO : however, alt+b is able to pickup the other Unity window, so likely we can hijack that and use that list
hs.hotkey.bind("alt", "9", openswitch("Unity"))
-- hs.hotkey.bind("alt", "9", switchUnityEditor)

-- note:
-- oddly, even for this "native" solution, only 1 zen window is available on load
-- only when i hv focused on the other zen window at least once, only then will it appear on the list
-- similar behavior with hs.window.filter and the custom switcher
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
local nextWindow = hs.window.switcher.nextWindow
hs.hotkey.bind("alt", "tab", nextWindow, nil, nextWindow)
