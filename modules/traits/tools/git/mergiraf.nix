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
        programs.mergiraf = {
          enable = true;
          enableGitIntegration = true;
        };
      };
    };
}
