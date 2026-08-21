{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:

      {
        options.traits.powertop = {
          enable = lib.mkEnableOption "PowerTOP" // {
            default = config.hardware.facter.report.hardware.system.form_factor or { } == "laptop";
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
