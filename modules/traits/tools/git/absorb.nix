{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = nixosConfig.traits.git;
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
