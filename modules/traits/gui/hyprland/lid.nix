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
        wayland.windowManager.hyprland.settings.bindl = [
          # Lid management
          # https://wiki.hypr.land/Configuring/Binds/#switches
          # https://github.com/hyprwm/Hyprland/discussions/11093
          '', switch:on:Lid Switch,  exec, hyprctl         keyword monitorv2[eDP-1]:disabled 1''
          '', switch:off:Lid Switch, exec, hyprctl --batch keyword monitorv2[eDP-1]:disabled 0 \; keyword monitorv2[eDP-1]:mode preferred, position auto, scale 1''
        ];
      };
    };
}
