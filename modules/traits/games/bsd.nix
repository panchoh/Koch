{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.games.bsd = {
          enable = lib.mkEnableOption "BSD Games" // {
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
        cfg = nixosConfig.traits.games.bsd;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.fish.interactiveShellInit = ''
            if not test -f ~/.silent
                echo
                fortune -a
                echo
            end
          '';

          home.packages = [

            pkgs.nbsdgames

            # bsdgames provides ‘fish’, which conflicts with the ‘fish’ shell
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
  };
}
