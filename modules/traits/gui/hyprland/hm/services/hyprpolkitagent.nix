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
    services.hyprpolkitagent.enable = true;

    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "pin,         initialTitle:Hyprland Polkit Agent"
        "noanim 1,    initialTitle:Hyprland Polkit Agent"
        "xray 1,      initialTitle:Hyprland Polkit Agent"
        "dimaround 1, initialTitle:Hyprland Polkit Agent"
        "stayfocused, initialTitle:Hyprland Polkit Agent"
      ];
    };
  };
}
