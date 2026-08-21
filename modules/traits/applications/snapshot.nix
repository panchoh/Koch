{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:

      {
        options.traits.snapshot = {
          enable = lib.mkEnableOption "Snapshot" // {
            default = config.hardware.facter.report.hardware or { } ? camera;
          };
        };
      };

    homeModules.default =
      {
        config,
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.snapshot;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.snapshot
          ];

          xdg.userDirs = {
            pictures = lib.mkForce "${config.home.homeDirectory}/Pictures";
            videos = lib.mkForce "${config.home.homeDirectory}/Videos";
          };
        };
      };
  };
}
