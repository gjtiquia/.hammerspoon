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
-- Cycle window widths (global, no persistence).
-- alt+right: next width from set, right-aligned. alt+left: previous, left-aligned.
local window_cycle_seq = { 1/2, 1/3, 1/5, 2/3, 4/5 }
-- Fractional tolerance used when matching current window width to a candidate fraction.
-- Example: 0.06 means ±6% of the screen width.
local width_fraction_tolerance = 0.10

local function getAlignment(win, sf)
    -- return "left", "right", or "other" based on window x position
    local wf = win:frame()
    local pixel_tolerance = math.floor(width_fraction_tolerance * sf.w + 0.5)
    if math.abs(wf.x - sf.x) <= pixel_tolerance then
        return "left"
    end
    if math.abs((wf.x + wf.w) - (sf.x + sf.w)) <= pixel_tolerance then
        return "right"
    end
    return "other"
end

local function nearestIndex(curr, side, win, sf)
    -- Match both fraction (within tolerance) and alignment (left/right) matching requested side.
    for i, v in ipairs(window_cycle_seq) do
        if math.abs(curr - v) <= width_fraction_tolerance then
            local align = getAlignment(win, sf)
            if align == side then
                return i
            end
        end
    end
    return nil
end

local function applyFractionToSide(win, fraction, side)
    if not win then return end
    local screen = win:screen()
    if not screen then return end
    local sf = screen:frame()
    local newW = math.floor(sf.w * fraction + 0.5)
    local newH = sf.h
    local newY = sf.y
    local newX = (side == "right") and (sf.x + sf.w - newW) or sf.x
    win:setFrame({ x = newX, y = newY, w = newW, h = newH }, 0)
end

local function cycleWindow(win, side)
    -- Advance to the next fraction in window_cycle_seq regardless of which key was pressed.
    if not win then return end
    local sf = win:screen():frame()
    local wf = win:frame()
    local curr_frac = wf.w / sf.w
    local idx = nearestIndex(curr_frac, side, win, sf)
    if not idx then
        idx = 1 -- start at 1/2 if no match
    else
        idx = (idx % #window_cycle_seq) + 1
    end
    applyFractionToSide(win, window_cycle_seq[idx], side)
end

hs.hotkey.bind("alt", "left", function()
    cycleWindow(hs.window.focusedWindow(), "left")
end)

hs.hotkey.bind("alt", "right", function()
    cycleWindow(hs.window.focusedWindow(), "right")
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
