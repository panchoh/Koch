{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.os.fish;
      in
      {
        options.traits.os.fish = {
          enable = lib.mkEnableOption "fish" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          users.defaultUserShell = pkgs.fish;
          programs.fish = {
            enable = true;
            useBabelfish = true; # https://github.com/bouk/babelfish
            interactiveShellInit = ''
              set -g fish_greeting
            '';
          };
        };
      };

    homeModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.fish;
      in
      {
        options.traits.hm.fish = {
          enable = lib.mkEnableOption "fish" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          programs = {
            fish = {
              enable = true;
              preferAbbrs = true;
              shellAbbrs = {
                "..." = "../..";
              };
              shellAliases = {
                e = "$EDITOR --no-wait";
              };
            };
            starship = {
              enableInteractive = true;
              enableTransience = true;
            };
          };
        };
      };
  };
}
