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
      pkgs.tig
      pkgs.meld
      pkgs.vbindiff
    ];

    programs.git = {
      enable = true;
      userName = box.userDesc or "Alice Q. User";
      userEmail = box.userEmail or "alice@example.org";
      extraConfig = {
        init.defaultBranch = "master";
        merge.conflictStyle = "zdiff3";
        github.user = box.githubUser or "aliceq";
        absorb = {
          maxStack = 50;
          oneFixupPerCommit = true;
          autoStageIfNothingStaged = true;
        };
      };
      delta = {
        enable = false;
        options.side-by-side = true;
      };
      difftastic = {
        enable = true;
        # background = "dark";
        display = "side-by-side-show-both";
      };
      signing = {
        key = box.gpgSigningKey;
        signByDefault = true;
      };
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
      extensions = [ pkgs.gh-eco ];
    };
  };
}
