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
      workspace = [
        "2, defaultName:Chromium, on-created-empty: chromium"
        "3, defaultName:Chrome,   on-created-empty: google-chrome-stable"
        "4, defaultName:Firefox,  on-created-empty: firefox"
      ];
    };
  };
}
