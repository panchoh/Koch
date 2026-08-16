{
  flake.homeModules.default =
    {
      config,
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.git;
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
