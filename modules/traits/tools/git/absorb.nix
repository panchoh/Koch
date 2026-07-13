{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.traits.hm.git;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.git-absorb
        ];
        programs.git.settings.absorb = {
          maxStack = 50;
          oneFixupPerCommit = true;
          autoStageIfNothingStaged = true;
        };
      };
    };
}
