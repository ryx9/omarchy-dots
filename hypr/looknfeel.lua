-- Change the default Omarchy look'n'feel.

pcall(dofile, os.getenv("HOME") .. "/.config/omarchy/plugins/omacale.bar/omacale.lua")
-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
	general = {
		-- No gaps between windows or borders.
		gaps_in = 10,
		gaps_out = 30,
		border_size = 2,

		-- Change to niri-like side-scrolling layout.
		layout = "dwindle",
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
	decoration = {
		-- Use round window corners.
		rounding = 8,

		blur = {
			enabled = true,
			size = 7,
			passes = 3,
		},
		-- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
		dim_inactive = true,
		dim_strength = 0.15,
	},
})

-- Make Nautilus slightly transparent.
-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
hl.window_rule({
	match = {
		class = "^org\\.gnome\\.Nautilus$",
	},
	opacity = "0.99 override 0.99 override",
})
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
hl.config({
	layout = {
		-- Avoid overly wide single-window layouts on wide screens.
		single_window_aspect_ratio = { 3, 4 },
	},
})

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
hl.config({
	scrolling = {
		-- See only one column per screen instead of two.
		column_width = 0.97,
	},
})
