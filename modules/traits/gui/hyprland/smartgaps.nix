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
          # https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/#smart-gaps-ignoring-special-workspaces
          workspace_rule = [
            {
              workspace = "s[true]";
              gaps_out = 100;
              gaps_in = 50;
            }
            {
              workspace = "w[tv1] s[false]";
              gaps_out = 0;
              gaps_in = 0;
            }
            {
              workspace = "f[1] s[false]";
              gaps_out = 0;
              gaps_in = 0;
            }
          ];
          window_rule = [
            {
              match = {
                float = false;
                workspace = "w[tv1] s[false]";
              };
              # REVIEW: use these when they land with Hyprland 0.55.5
              # no_border = true;
              # no_rounding = true;
              border_size = 0;
              rounding = 0;
            }
            {
              match = {
                float = false;
                workspace = "f[1] s[false]";
              };
              # REVIEW: use these when they land with Hyprland 0.55.5
              # no_border = true;
              # no_rounding = true;
              border_size = 0;
              rounding = 0;
            }
          ];
        };
      };
    };
}
