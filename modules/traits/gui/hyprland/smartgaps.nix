{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.settings = {
          # https://wiki.hypr.land/Configuring/Workspace-Rules/#smart-gaps-ignoring-special-workspaces
          workspace = [
            "s[true],         gapsout:100, gapsin:50"
            "s[false] w[tv1], gapsout:0,   gapsin:0"
            "s[false] f[1],   gapsout:0,   gapsin:0"
          ];
          windowrulev2 = [
            "bordersize 0, floating:0, onworkspace:s[false] w[tv1]"
            "rounding   0, floating:0, onworkspace:s[false] w[tv1]"
            "bordersize 0, floating:0, onworkspace:s[false] f[1]"
            "rounding   0, floating:0, onworkspace:s[false] f[1]"
          ];
        };
      };
    };
}
