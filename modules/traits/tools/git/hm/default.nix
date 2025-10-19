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
  imports = [
    ./programs/tig.nix
  ];

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
    ];

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = box.userDesc or "Alice Q. User";
          email = box.userEmail or "alice@example.org";
        };
        init.defaultBranch = "master";
        merge.conflictStyle = "zdiff3";
        github.user = box.githubUser or "aliceq";
        absorb = {
          maxStack = 50;
          oneFixupPerCommit = true;
          autoStageIfNothingStaged = true;
        };
      };
      signing = {
        key = box.gpgSigningKey;
        signByDefault = true;
      };
    };

    programs.delta = {
      enable = false;
      enableGitIntegration = true;
      options.side-by-side = true;
    };

    programs.difftastic = {
      enable = true;
      git.enable = true;
      # background = "dark";
      options.display = "side-by-side-show-both";
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
      extensions = [ pkgs.gh-eco ];
    };
  };
}
