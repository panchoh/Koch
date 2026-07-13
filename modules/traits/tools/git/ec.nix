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
        programs.ec = {
          enable = true;
          enableGitIntegration = true;
        };
      };
    };
}
