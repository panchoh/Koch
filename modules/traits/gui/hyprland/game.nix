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
        # https://wiki.hypr.land/Configuring/Basics/Variables/#render
        wayland.windowManager.hyprland.settings.config.render.direct_scanout = 2;
      };
    };
}
