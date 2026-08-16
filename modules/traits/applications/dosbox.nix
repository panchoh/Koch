{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.dosbox = {
          enable = lib.mkEnableOption "DOSBox Staging" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.dosbox;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.dosbox-staging
          ];
        };
      };
  };
}
