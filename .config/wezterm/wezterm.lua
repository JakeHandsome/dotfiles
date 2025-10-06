local wezterm = require("wezterm")

wezterm.on("update-right-status", function(window, pane)
   window:set_right_status(window:active_workspace())
end)

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
   s = string.gsub(s, ".exe", "")
   return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
   local pane = tab.active_pane
   local title = 1 + tab.tab_index
      .. ": "
      .. pane.current_working_dir.file_path
      .. " - "
      .. basename(pane.foreground_process_name)
   return {
      { Text = " " .. title .. " " },
   }
end)

local font = "Iosevka"
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
   font = "Iosevka Nerd Font"
end

local config = {
   check_for_updates = true,
   color_scheme = "Gruvbox dark, hard (base16)",
   inactive_pane_hsb = {
      hue = 1.0,
      saturation = 1.0,
      brightness = 1.0,
   },
   front_end = "WebGpu",
   font_size = 11.0,
   launch_menu = {},
   leader = { key = "a", mods = "CTRL" },
   disable_default_key_bindings = true,
   set_environment_variables = {},
   font = wezterm.font(font),
   hide_tab_bar_if_only_one_tab = false,
   tab_bar_at_bottom = true,
   -- Increase the launch size
   initial_rows = 40,
   initial_cols = 200,
}
config.keys = {
   -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
   { key = "a", mods = "CTRL", action = wezterm.action({ SendString = "\x01" }) },
   -- Fix <C-I> in nvim
   { key = "i", mods = "CTRL", action = wezterm.action({ SendKey = { key = "i", mods = "CTRL" } }) },
   { key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
   {
      key = "|",
      mods = "LEADER|SHIFT",
      action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
   },
   { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
   { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
   { key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
   { key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
   { key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
   { key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
   { key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
   { key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
   { key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
   { key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
   { key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
   { key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
   { key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
   { key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
   { key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
   { key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
   { key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
   { key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
   { key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
   { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

   { key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
   { key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
   { key = "PageUp", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(1) },
   { key = "PageDown", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(-1) },
   {
      key = "c",
      mods = "CTRL",
      action = wezterm.action_callback(function(window, pane)
         selection_text = window:get_selection_text_for_pane(pane)
         is_selection_active = string.len(selection_text) ~= 0
         if is_selection_active then
            window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)
         else
            window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
         end
      end),
   },
   { key = "P", mods = "LEADER|CTRL", action = wezterm.action.ActivateCommandPalette },

   -- Prompt for a name to use for a new workspace and switch to it.
   {
      key = "w",
      mods = "LEADER",
      action = wezterm.action.PromptInputLine({
         description = wezterm.format({
            { Attribute = { Intensity = "Bold" } },
            { Foreground = { AnsiColor = "Fuchsia" } },
            { Text = "Enter name for new workspace" },
         }),
         action = wezterm.action_callback(function(window, pane, line)
            -- line will be `nil` if they hit escape without entering anything
            -- An empty string if they just hit enter
            -- Or the actual line of text they wrote
            if line then
               window:perform_action(
                  wezterm.action.SwitchToWorkspace({
                     name = line,
                  }),
                  pane
               )
            end
         end),
      }),
   },

   -- Show the launcher in fuzzy selection mode and have it list all workspaces
   -- and allow activating one.
   {
      key = "s",
      mods = "LEADER",
      action = wezterm.action.ShowLauncherArgs({
         flags = "FUZZY|WORKSPACES",
      }),
   },
}
config.mouse_bindings = {
   {
      event = { Down = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = wezterm.action.PasteFrom("Clipboard"),
   },
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
   config.term = "" -- Set to empty so FZF works on windows
   config.default_prog = {
      "cmd.exe",
      "/k",
      "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/Common7/Tools/VsDevCmd.bat",
      "-startdir=none",
      "-arch=x64",
      "-host_arch=x64",
   }

   -- Find installed visual studio version(s) and add their compilation
   -- environment command prompts to the menu
   for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
      local year = vsvers:gsub("Microsoft Visual Studio/", "")
      table.insert(config.launch_menu, {
         label = "x64 Native Tools VS " .. year,
         args = {
            "cmd.exe",
            "/k",
            "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
         },
      })
   end
   table.insert(config.launch_menu, { label = "PowerShell", args = { "powershell.exe", "-NoLogo" } })
else
   table.insert(config.launch_menu, { label = "bash", args = { "bash", "-l" } })
   table.insert(config.launch_menu, { label = "fish", args = { "fish", "-l" } })
end

return config
