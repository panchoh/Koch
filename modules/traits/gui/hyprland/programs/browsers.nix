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
          bind = [
            "SUPER,       slash, exec, chromium"
            "SUPER SHIFT, slash, exec, google-chrome-stable"
          ];
        };
      };
    };
}
