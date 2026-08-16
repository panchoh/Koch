{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.powertop = {
          enable = lib.mkEnableOption "PowerTOP" // {
            default = box.isLaptop or false;
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
        cfg = nixosConfig.traits.powertop;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.powertop
          ];
        };
      };
  };
}
