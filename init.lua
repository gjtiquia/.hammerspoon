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

-- Window cycle (simplified): two sequences per side, no app min-width checks.
-- Small sequence: 1/2 -> 1/3 -> 1/5
-- Large sequence: 1/2 -> 2/3 -> 4/5
local small_seq = { 1/2, 1/3, 1/5 }
local large_seq = { 1/2, 2/3, 4/5 }
local width_fraction_tolerance = 0.06 -- ±6% of screen width for matching

local function pixelTolForScreen(sf)
    return math.floor(width_fraction_tolerance * sf.w + 0.5)
end

local function getAlignment(win, sf)
    local wf = win:frame()
    local tol = pixelTolForScreen(sf)
    if math.abs(wf.x - sf.x) <= tol then return "left" end
    if math.abs((wf.x + wf.w) - (sf.x + sf.w)) <= tol then return "right" end
    return "other"
end

local function nearestIndexForSeq(curr_frac, seq, side, win, sf)
    -- match fraction within tolerance and alignment
    for i, v in ipairs(seq) do
        if math.abs(curr_frac - v) <= width_fraction_tolerance then
            if getAlignment(win, sf) == side then
                return i
            end
        end
    end
    return nil
end

local function applyFractionSimple(win, fraction, side)
    if not win then return end
    local screen = win:screen()
    if not screen then return end
    local sf = screen:frame()
    local newW = math.floor(sf.w * fraction + 0.5)
    local newX = (side == "right") and (sf.x + sf.w - newW) or sf.x
    local newFrame = { x = newX, y = sf.y, w = newW, h = sf.h }
    win:setFrame(newFrame, 0)
end

local function cycleWithSeq(win, seq, side)
    if not win then return end
    local screen = win:screen()
    if not screen then return end
    local sf = screen:frame()
    local wf = win:frame()
    local curr_frac = wf.w / sf.w
    local n = #seq

    local idx = nearestIndexForSeq(curr_frac, seq, side, win, sf)
    if not idx then idx = 1 end
    local next_idx = (idx % n) + 1

    applyFractionSimple(win, seq[next_idx], side)
end

-- Hotkeys mapping:
-- alt+right -> right-aligned, small_seq
-- alt+shift+left -> right-aligned, large_seq
-- alt+left -> left-aligned, small_seq
-- alt+shift+right -> left-aligned, large_seq

hs.hotkey.bind({"alt"}, "right", function()
    cycleWithSeq(hs.window.focusedWindow(), small_seq, "right")
end)

hs.hotkey.bind({"alt", "shift"}, "left", function()
    cycleWithSeq(hs.window.focusedWindow(), large_seq, "right")
end)

hs.hotkey.bind({"alt"}, "left", function()
    cycleWithSeq(hs.window.focusedWindow(), small_seq, "left")
end)

hs.hotkey.bind({"alt", "shift"}, "right", function()
    cycleWithSeq(hs.window.focusedWindow(), large_seq, "left")
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
