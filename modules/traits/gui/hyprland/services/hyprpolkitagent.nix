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
        services.hyprpolkitagent.enable = true;

        wayland.windowManager.hyprland.settings = {
          windowrule = [
            "pin on, no_anim 1, xray 1, dim_around 1, stay_focused on, match:initial_title Hyprland Polkit Agent"
          ];
        };
      };
    };
}
