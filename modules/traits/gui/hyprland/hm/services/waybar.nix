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

    wayland.windowManager.hyprland.settings.bind = [
      # Toggle Waybar visibility
      "SUPER, B, exec, killall -USR1 .waybar-wrapped"
    ];
  };
}
