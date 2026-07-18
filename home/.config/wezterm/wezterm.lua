local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

-- No GPU passthrough configured in this WSL instance (no hardware.graphics.enable,
-- no WSL D3D12 Mesa driver wiring) - EGL/Zink fails to find a device. Software
-- rendering avoids that entirely; fine for a terminal.
config.front_end = "Software"

return config
