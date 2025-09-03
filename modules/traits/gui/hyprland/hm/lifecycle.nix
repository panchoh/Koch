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
      "CONTROL ALT,   BackSpace, exit,"

      "SUPER,         Q,         forcerendererreload,"

      "SUPER,         X,         killactive,"
      "SUPER SHIFT,   X,         forcekillactive,"
      "SUPER CONTROL, X,         exec, hyprctl kill"
    ];
  };
}
