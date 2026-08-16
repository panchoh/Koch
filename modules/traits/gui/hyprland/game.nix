{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {

        # https://wiki.hypr.land/Configuring/Basics/Variables/#render
        wayland.windowManager.hyprland.settings.config.render.direct_scanout = 2;
      };
    };
}
