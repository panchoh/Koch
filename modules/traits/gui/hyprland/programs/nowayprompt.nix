{
  inputs,
  ...
}:

{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.wayprompt = {
          enable = true;
          package = inputs.nowayprompt.packages.${pkgs.stdenv.hostPlatform.system}.nowayprompt;
          settings.general.pin-square-amount = 32;
        };

        services.gpg-agent.pinentry.package = config.programs.wayprompt.package;

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
