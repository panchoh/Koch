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
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
        };
      };
    };
}
