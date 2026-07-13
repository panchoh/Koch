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
        cfg = config.traits.os.fish;
      in
      {
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
        ...
      }:
      let
        cfg = config.traits.hm.fish;
      in
      {
        config = lib.mkIf cfg.enable {
          programs = {
            fish = {
              enable = true;
              shellAbbrs = {
                g = "git";
                gf = "git fetch --prune --prune-tags";
                gfa = "git fetch --prune --prune-tags --all";
                gm = "git merge";
                gp = "git push";
                gpf = "git push --force-with-lease";
                tf = "tig FETCH_HEAD";
                l = "less";
                t = "task";
                "..." = "../..";
              };
              shellAliases = {
                e = "$EDITOR --no-wait";
              };
            };
          };
        };
      };
  };
}
