{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.nix-init = {
          enable = lib.mkEnableOption "nix-init" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        box ? null,
        ...
      }:

      let
        cfg = nixosConfig.traits.nix-init;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.nix-init = {

            enable = true;

            settings = {
              commit = true;
              maintainers = [ box.githubUser ];
            };
          };
        };
      };
  };
}
