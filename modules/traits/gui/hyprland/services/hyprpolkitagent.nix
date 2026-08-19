{
  flake.homeModules.default =
    {
      config,
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

        # NOTE: it does not work; further debugging is needed
        xdg.configFile."hyprpolkitagent/hyprpolkitagent.conf".text = lib.hm.generators.toHyprconf {
          attrs = {
            general = {
              password_field_width = 120;
              window_width = 1200;
              window_height = 800;
              show_details = true;
            };
          };
        };

        # REVIEW: maybe X-Reload-Triggers if hyprpolkitagent supports it?
        systemd.user.services.hyprpolkitagent.Unit.X-Restart-Triggers = [
          config.xdg.configFile."hyprpolkitagent/hyprpolkitagent.conf".source
        ];

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
