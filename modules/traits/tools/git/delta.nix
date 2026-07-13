{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.git;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.delta = {
          enable = !config.programs.difftastic.enable;
          enableGitIntegration = true;
          options.side-by-side = true;
        };
      };
    };
}
