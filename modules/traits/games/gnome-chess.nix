{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.games.gnome-chess = {
          enable = lib.mkEnableOption "GNOME Chess" // {
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
        cfg = nixosConfig.traits.games.gnome-chess;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.gnome-chess
            pkgs.stockfish
          ];

          # https://wiki.nixos.org/wiki/GNOME
          dconf.settings = {
            "org/gnome/Chess" = {
              show-numbering = true;
            };
          };
        };
      };
  };
}
