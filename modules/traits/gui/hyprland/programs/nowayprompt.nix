{
  inputs,
  ...
}:

{
  flake.homeModules.default =
    {
      config,
      nixosConfig,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
    in
    {
      imports = [ inputs.nowayprompt.homeModules.stylix ];

      config = lib.mkIf cfg.enable {

        programs.nowayprompt = {
          enable = true;
          settings.general.pin-square-amount = 32;
        };

        services.gpg-agent.pinentry.package = config.programs.nowayprompt.package;

        systemd.user.services.gpg-agent.Unit.X-Reload-Triggers = [
          config.services.gpg-agent.pinentry.package
          config.xdg.configFile."nowayprompt/config.ini".source
        ];

        wayland.windowManager.hyprland.settings.layer_rule = [
          {
            match.namespace = "^nowayprompt$";
            xray = true;
            dim_around = true;
          }
        ];
      };
    };

}
