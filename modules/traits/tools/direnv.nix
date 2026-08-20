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

          programs.direnv = {

            enable = true;

            config = {

              global = {
                disable_stdin = true;
                strict_env = true;
                hide_env_diff = true;
              };

              whitelist = {
                # TODO: extract path/username; look for disko-and-funk
                exact = [
                  "~/sandbox/panchoh/Koch"
                ];
              };
            };

            # REVIEW: drop if https://github.com/nix-community/home-manager/issues/9822 gets fixed
            nix-direnv.enable = true;
          };
        };
      };
  };
}
