{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.os.games.misc;
      in
      {
        options.traits.os.games.misc = {
          enable = lib.mkEnableOption "misc games" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          nixpkgs.config.allowUnfreePackages = [ "abuse" ];
        };
      };

    homeModules.default =
      {
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.hm.games.misc;
      in
      {
        options.traits.hm.games.misc = {
          enable = lib.mkEnableOption "misc games" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.abuse
            pkgs.beneath-a-steel-sky
            pkgs.bb
            pkgs.crawl
            pkgs.sl
            pkgs.fastfetch
            pkgs.hyperrogue
            pkgs.hyperspeedcube
            pkgs.notcurses
            pkgs.torus-trooper

            pkgs.lolcat
            pkgs.figlet
            pkgs.toilet
            pkgs.banner

            pkgs.neo-cowsay
            pkgs.charasay
            pkgs.ponysay

            pkgs.ratty
          ];
        };
      };
  };
}
