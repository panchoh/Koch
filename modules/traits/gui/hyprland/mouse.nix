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
          bind = [
            # Paste
            "SUPER, V, sendshortcut, , mouse:274, activewindow"

            # Cycle through active workspaces
            "SUPER, mouse_down, workspace, e+1"
            "SUPER, mouse_up,   workspace, e-1"
          ];
          bindm = [
            # Move/resize windows with SUPER + LMB/RMB and dragging
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          cursor = {
            inactive_timeout = 5;
            hide_on_key_press = true;
          };
          general = {
            resize_on_border = true;
            hover_icon_on_border = true;
          };
          input = {
            follow_mouse = 1;
            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
            touchpad.natural_scroll = false;
          };
          misc.mouse_move_enables_dpms = true;
        };
      };
    };
}
