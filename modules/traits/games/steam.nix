{
  flake = {

    nixosModules.default =
      {
        config,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = config.traits.steam;
      in
      {
        options.traits.steam = {
          enable = lib.mkEnableOption "Steam" // {
            default = false;
          };
        };

        config = lib.mkIf cfg.enable {

          nixpkgs.config.allowUnfreePackages = [
            "steam"
            "steam-unwrapped"
            "steamcmd"
          ];

          hardware.graphics.enable32Bit = true;

          programs.steam = {
            enable = true;
            extraCompatPackages = [ pkgs.proton-ge-bin ];
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
        cfg = nixosConfig.traits.steam;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.steamcmd
            pkgs.steam-run
            pkgs.steam-tui
            pkgs.protonup-qt
          ];
        };
      };
  };
}
