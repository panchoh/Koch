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
    # https://wiki.hypr.land/Configuring/Variables/#render
    wayland.windowManager.hyprland.settings.render.direct_scanout = 2;
  };
}
