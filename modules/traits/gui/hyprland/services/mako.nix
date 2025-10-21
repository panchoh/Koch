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
        services.mako = {
          enable = true;
          settings.border-radius = 5;
        };

        wayland.windowManager.hyprland.settings.bind = [
          # Handle notifications
          "SUPER,       Escape, exec, makoctl dismiss"
          "SUPER SHIFT, Escape, exec, makoctl dismiss --all"
          "SUPER,       U,      focusurgentorlast,"
        ];
      };
    };
}
