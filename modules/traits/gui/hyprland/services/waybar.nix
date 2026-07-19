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
        home.packages = [ ];

        programs.waybar = {
          enable = true;
          systemd.enable = true;
          settings = {
            mainBar = {
              start_hidden = true;
              layer = "top";
              position = "bottom";
              height = 30;
              modules-left = [
                "hyprland/windowcount"
                "hyprland/workspaces"
              ];
              modules-center = [
                "hyprland/submap"
                "hyprland/window"
              ];
              modules-right = [
                "temperature"
              ]
              ++ lib.optionals config.traits.hm.mpd.enable [
                "mpd"
              ];
              "hyprland/workspaces" = {
                # active-only = true;
                show-special = true;
                special-visible-only = true;
              };
            };
          };
        };

        wayland.windowManager.hyprland.settings = {
          layer_rule = [
            {
              match.namespace = "^waybar$";
              dim_around = false;
              no_anim = true;
            }
          ];
          bind = [
            {
              _args = [
                # Toggle Waybar visibility
                "SUPER + B"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("killall -USR1 .waybar-wrapped")'')
              ];
            }
          ];
        };
      };
    };
}
