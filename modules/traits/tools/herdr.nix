{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.herdr;
    in
    {
      options.traits.hm.herdr = {
        enable = lib.mkEnableOption "herdr" // {
          default = true;
        };
      };

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
