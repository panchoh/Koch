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
          windowrule = [
            "border_size 0, rounding 0, match:float 0, match:workspace s[false] w[tv1]"
            "border_size 0, rounding 0, match:float 0, match:workspace s[false] f[1]"
          ];
        };
      };
    };
}
