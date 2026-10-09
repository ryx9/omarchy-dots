if hl.plugin.hyprglass then
	local hg = hl.plugin.hyprglass

	hg.config({
		default_theme = "dark",
		default_preset = "liquid",

		tint_color = 0x00000000,

		brightness = 1.0,

		dark = {
			brightness = 1.0,
			contrast = 1.0,
			saturation = 1.0,
			adaptive_dim = 0.0,
		},

		layers = {
			enabled = true,
			live_resample = true,
			live_resample_fps = 30,
		},
	})

	hg.preset("liquid", {
		-- ZERO FROST / ZERO MIST
		blur_strength = 0.0,
		blur_iterations = 0,

		-- Pure optical distortion
		refraction_strength = 1.0,
		refraction_flow = 0.85,
		refraction_spread = 0.08,

		-- Very subtle dispersion
		chromatic_aberration = 0.18,

		-- Essentially transparent
		glass_opacity = 0.15,

		-- Strong glass edge
		bevel = 0.9,
		bevel_size = 0.16,

		brightness = 1.0,
		contrast = 1.0,
		saturation = 1.0,

		dark = {
			brightness = 1.0,
			contrast = 1.0,
			saturation = 1.0,
			adaptive_dim = 0.0,
		},
	})

	hg.layer("quickshell:bar", {
		preset = "liquid",
		mask_mode = "region",
	})

	hg.layer("quickshell:bezel", {
		preset = "liquid",
		mask_threshold = 0.2,
	})
end
