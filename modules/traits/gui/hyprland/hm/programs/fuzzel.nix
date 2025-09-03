{
  config,
  lib,
  nixosConfig,
  ...
}:
let
  cfg = config.traits.hm.hyprland;
  size = toString (nixosConfig.stylix.fonts.sizes.desktop + 2);
in
{
  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "Iosevka Comfy Duo:size=${size}:weight=extralight";
          layer = "overlay";
          terminal = lib.getExe config.programs.foot.package;
        };
      };
    };

    wayland.windowManager.hyprland.settings = {
      # Alternatively:
      # Start fuzzel opens fuzzel on first press, closes it on second
      # bindr = SUPER, SUPER_L, exec, pkill fuzzel || fuzzel

      bind = [ "SUPER, P, exec, fuzzel" ];

      layerrule = [
        "xray 1,    launcher"
        "dimaround, launcher"
      ];
    };
  };
}
