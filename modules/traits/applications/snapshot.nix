{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.snapshot = {
          enable = lib.mkEnableOption "Snapshot" // {
            default = box.hasCamera or false;
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
