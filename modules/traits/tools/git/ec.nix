{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.git;
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
