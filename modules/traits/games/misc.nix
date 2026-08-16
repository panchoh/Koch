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
        cfg = config.traits.games.misc;
      in
      {
        options.traits.games.misc = {
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
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.games.misc;
      in
      {
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
