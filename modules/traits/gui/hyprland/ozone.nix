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
          env = lib.mapAttrsToList (name: value: "${name}, ${toString value}") {
            NIXOS_OZONE_WL = 1;
          };
        };
      };
    };
}
