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

        # https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland/
        wayland.windowManager.hyprland.xdph.settings.screencopy.allow_token_by_default = true;
      };
    };
}
