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
    wayland.windowManager.hyprland = {
      settings = {
        animations.enabled = true;
        animation = [
          "windows, 1, 8, default, popin 80%"
        ];
        general = {
          border_size = 2;
          "col.active_border" = lib.mkForce "rgba(33ccffee) rgba(00ff99ee) 45deg";
          # "col.inactive_border" = lib.mkForce "rgba(595959aa)";
        };
        decoration = {
          rounding = 5;
          dim_inactive = true;
          dim_strength = 0.1;
        };
        misc = {
          # https://www.reddit.com/r/hyprland/comments/zoeqoz/anyway_to_remove_the_hyprland_startup_logo/
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 2;
        };
      };
    };
  };
}
