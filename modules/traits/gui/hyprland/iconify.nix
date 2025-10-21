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
          # Simulate “iconify”
          "SUPER, W, togglespecialworkspace,         magic"
          "SUPER, W, movetoworkspace,                +0"
          "SUPER, W, togglespecialworkspace,         magic"
          "SUPER, W, movetoworkspace,        special:magic"
          "SUPER, W, togglespecialworkspace,         magic"
        ];
      };
    };
}
