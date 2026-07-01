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
        programs.herdr = {
          enable = true;
          settings = {
            onboarding = false;
            version_check = false;
            manifest_check = false;
            # REVIEW: if herdr becomes supported by stylix
            theme.name = "dracula";
          };
        };
      };
    };
}
