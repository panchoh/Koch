{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {

        services.hyprpolkitagent.enable = true;

        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.initial_title = "Hyprland Polkit Agent";
            no_anim = true;
            xray = true;
            dim_around = true;
            stay_focused = true;
          }
        ];
      };
    };
}
