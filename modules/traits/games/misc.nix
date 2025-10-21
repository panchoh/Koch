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
      cfg = config.traits.hm.games.misc;
    in
    {
      options.traits.hm.games.misc = {
        enable = lib.mkEnableOption "games" // {
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
          pkgs.neofetch
          pkgs.hyperrogue
          pkgs.notcurses
          pkgs.torus-trooper

          pkgs.figlet
          pkgs.toilet
          pkgs.banner

          pkgs.neo-cowsay
          pkgs.charasay

          pkgs.nbsdgames
          # bsdgames:
          # - provides `wtf`, which conflicts with `fish` shell
          # FIXME: PR with the current BSD Games, which fixes this and more
          (pkgs.stdenv.mkDerivation {
            pname = "bsdgames-custom";
            version = pkgs.bsdgames.version;
            src = pkgs.bsdgames;
            installPhase = ''
              mkdir -p $out
              cp -a ${pkgs.bsdgames}/. $out/
              chmod +w $out/bin
              mv -f $out/bin/fish $out/bin/gofish
            '';
          })
        ];
      };
    };
}
