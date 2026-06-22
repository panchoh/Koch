{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.libinput # for libinput list-devices
          pkgs.wev # for wev -f wl_pointer
          pkgs.wlrctl # for wlrctl pointer click left
        ];
        wayland.windowManager.hyprland.settings = {
          config = {
            cursor = {
              inactive_timeout = 5;
              hide_on_key_press = true;
              persistent_warps = true;
              warp_on_change_workspace = 1;
              warp_on_toggle_special = 1;
            };
            general = {
              resize_on_border = true;
              hover_icon_on_border = true;
            };
            input = {
              follow_mouse = 1;
              sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
              touchpad = {
                natural_scroll = false;
                disable_while_typing = true;
              };
            };
            misc.middle_click_paste = true;
            binds = {
              drag_threshold = 10; # Fire a drag event only after dragging for more than 10 px
              workspace_center_on = 1; # Center cursor on last active window for the workspace
            };
          };
          bind = [
            {
              _args = [
                "SUPER + V"
                # Paste
                (lib.generators.mkLuaInline ''hl.dsp.send_shortcut({ mods = "", key = "mouse:274", window = "activewindow" })'')
              ];
            }
            {
              _args = [
                "SUPER + mouse:272"
                # Float window with SUPER + LMB and dragging less than 10 px
                (lib.generators.mkLuaInline "hl.dsp.window.float()")
                {
                  mouse = true;
                  click = true;
                }
              ];
            }
            {
              _args = [
                "SUPER + mouse:272"
                # Move window with SUPER + LMB and dragging more than 10 px
                (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                { mouse = true; }
              ];
            }
            {
              _args = [
                "SUPER + mouse:273"
                # Resize window with SUPER + RMB and dragging
                (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                { mouse = true; }
              ];
            }
          ];
        };
      };
    };
}
