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
        cfg = config.traits.git;
      in
      {
        options.traits.git = {
          enable = lib.mkEnableOption "Git" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {

          # REVIEW: do we need this?
          programs.git = {
            enable = true;
            package = pkgs.gitMinimal;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = nixosConfig.traits.git;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.bvi
            pkgs.diffoscope
            pkgs.git-dive
            pkgs.git-town
            pkgs.gitg
            pkgs.gti
            pkgs.gitui
            pkgs.gittyup
            pkgs.gource
            pkgs.lazygit
            pkgs.vbindiff
            pkgs.diffnav
            pkgs.git-filter-repo
          ];

          programs = {

            git = {

              enable = true;
              package = pkgs.gitFull;

              settings = {

                branch = {
                  autoSetupMerge = "inherit";
                  autoSetupRebase = "remote";
                };

                core.pager = "less --+clear-screen --quit-if-one-screen";
                difftool.prompt = false;

                fetch = {
                  all = true;
                  prune = true;
                  pruneTags = true;
                };

                gui.pruneDuringFetch = true;
                github.user = box.githubUser or "aliceq";
                init.defaultBranch = "master";
                log.follow = true;
                merge.conflictStyle = lib.mkDefault "zdiff3"; # mergiraf forcibly sets its to "diff3"
                pager.difftool = true;
                pull.ff = "only";

                push = {
                  autoSetupRemote = true;
                  default = "matching";
                  followTags = true;
                };

                remote.pushDefault = "origin";

                user = {
                  name = box.userDesc or "Alice Q. User";
                  email = box.userEmail or "alice@example.org";
                };
              };

              signing =
                lib.optionalAttrs (box ? gpgSigningKey) {
                  key = box.gpgSigningKey;
                }
                // {
                  signByDefault = box ? gpgSigningKey;
                };
            };

            # https://github.com/mateusauler/git-worktree-switcher
            git-worktree-switcher.enable = true;

            fish.shellAbbrs = {
              g = "git";
              gb = "git branch --verbose --verbose";
              gba = "git branch --verbose --verbose --all";
              gf = "git fetch";
              gfa = "git fetch --no-all";
              gl = "git log";
              glo = "git log --oneline";
              glp = "git log --patch";
              gls = "git log --show-signature";
              gm = "git merge";
              gP = "git pull";
              gp = "git push";
              gpf = "git push --force-with-lease";
              gr = "git remote --verbose show";
              grn = "git remote --verbose show -n";
            };
          };
        };
      };
  };
}
