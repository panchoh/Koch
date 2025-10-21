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
        wayland.windowManager.hyprland.settings.bind = [
          "SUPER,       F, fullscreen"
          "SUPER ALT,   F, fullscreenstate, 1, 1" # maximize
          "SUPER SHIFT, F, fullscreenstate, 0, 2" # fullscreen within window
          "SUPER,       T, togglefloating, active"
        ];
      };
    };
}
