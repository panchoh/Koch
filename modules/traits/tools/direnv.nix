{
  flake = {
    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.direnv = {
          enable = lib.mkEnableOption "direnv" // {
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
        cfg = nixosConfig.traits.direnv;
      in
      {
        options.traits.direnv = {
          enable = lib.mkEnableOption "direnv" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {

          programs = {

            starship.settings.direnv.disabled = false;

            direnv = {

              enable = true;

              config = {

                global = {
                  disable_stdin = true;
                  strict_env = true;
                  hide_env_diff = true;
                };

                # TODO: extract path/username; look for disko-and-funk
                whitelist.exact = [ "~/sandbox/panchoh/Koch" ];
              };
            };
          };
        };
      };
  };
}
