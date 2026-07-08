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
        cfg = config.traits.os.git;
      in
      {
        options.traits.os.git = {
          enable = lib.mkEnableOption "Git" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {
          environment.systemPackages = [
            pkgs.gitFull
          ];
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
        cfg = config.traits.hm.git;
      in
      {
        options.traits.hm.git = {
          enable = lib.mkEnableOption "Git" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.bvi
            pkgs.diffoscope
            pkgs.git-absorb
            pkgs.git-doc
            pkgs.git-dive
            pkgs.git-town
            pkgs.gitg
            pkgs.gti
            pkgs.gitui
            pkgs.gittyup
            pkgs.gource
            pkgs.lazygit
            pkgs.meld
            pkgs.vbindiff
            pkgs.diffnav
          ];

          programs.git = {
            enable = true;
            settings = {
              absorb = {
                maxStack = 50;
                oneFixupPerCommit = true;
                autoStageIfNothingStaged = true;
              };
              alias = {
                ddiff = "diff --no-ext-diff";
                dlog = "log --ext-diff";
                dshow = "show --ext-diff";
              };
              diff.guitool = "meld";
              difftool.prompt = false;
              github.user = box.githubUser or "aliceq";
              init.defaultBranch = "master";
              # REVIEW: reenable if mergiraf git integration is not enabled
              # merge.conflictStyle = "zdiff3";
              pager.difftool = true;
              user = {
                name = box.userDesc or "Alice Q. User";
                email = box.userEmail or "alice@example.org";
              };
            };
            signing = {
              key = box.gpgSigningKey;
              signByDefault = true;
            };
          };

          programs.jujutsu = {
            enable = true;
            settings = {
              user = {
                name = box.userDesc or "Alice Q. User";
                email = box.userEmail or "alice@example.org";
              };
            };
          };

          programs.jjui.enable = true;

          programs.ec = {
            enable = true;
            enableGitIntegration = true;
          };

          programs.delta = {
            enable = false;
            enableGitIntegration = true;
            enableJujutsuIntegration = true;
            options.side-by-side = true;
          };

          programs.difftastic = {
            enable = true;
            git = {
              enable = true;
              mode = "both";
            };
            jujutsu.enable = true;
            options = {
              color = "always";
              display = "side-by-side-show-both";
              sort-paths = true;
              tab-width = 8;
            };
          };

          programs.mergiraf = {
            enable = true;
            enableGitIntegration = true;
            enableJujutsuIntegration = true;
          };

          programs.gh = {
            enable = true;
            settings.git_protocol = "ssh";
            extensions = [
              pkgs.gh-eco
              pkgs.gh-dash
              pkgs.gh-enhance
            ];
          };
        };
      };
  };
}
