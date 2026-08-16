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

        programs.mergiraf = {
          enable = true;
          enableGitIntegration = true;
        };
      };
    };
}
