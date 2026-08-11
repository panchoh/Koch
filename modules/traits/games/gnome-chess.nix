{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.games.gnome-chess;
    in
    {
      options.traits.hm.games.gnome-chess = {
        enable = lib.mkEnableOption "GNOME Chess" // {
          default = box.isStation or false;
        };
      };

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
}
