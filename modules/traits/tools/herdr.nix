{
  flake = {
    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.herdr = {
          enable = lib.mkEnableOption "herdr" // {
            default = true;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        ...
      }:

      let
        cfg = nixosConfig.traits.herdr;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.herdr = {

            enable = true;

            settings = {
              onboarding = false;

              remote.manage_ssh_config = false;

              # REVIEW: if herdr becomes supported by stylix
              theme.name = "dracula";

              update = {
                version_check = false;
                manifest_check = false;
              };
            };
          };
        };
      };
  };
}
