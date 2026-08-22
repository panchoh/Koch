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

        # REVIEW: config file feature present only in tip, must await for next release
        xdg.configFile."hyprpolkitagent/hyprpolkitagent.conf".text = lib.hm.generators.toHyprconf {
          attrs = {
            general = {
              password_field_width = 680;
              window_width = 800;
              window_height = 440;
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
