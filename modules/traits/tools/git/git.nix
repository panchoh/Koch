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
          programs.git = {
            enable = true;
            config.init.defaultBranch = "master";
          };
        };
      };

    homeModules.default =
      {
        config,
        lib,
        pkgs,
        nixosConfig,
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
          ];

          programs.git = {
            enable = true;
            package = pkgs.gitFull;
            settings = {
              core.pager = "less --+clear-screen --quit-if-one-screen";
              difftool.prompt = false;
              github.user = box.githubUser or "aliceq";
              init.defaultBranch = nixosConfig.programs.git.config.init.defaultBranch or "master";
              merge.conflictStyle = lib.mkDefault "zdiff3"; # mergiraf forcibly sets its to "diff3"
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

          # https://github.com/mateusauler/git-worktree-switcher
          programs.git-worktree-switcher.enable = true;
        };
      };
  };
}
