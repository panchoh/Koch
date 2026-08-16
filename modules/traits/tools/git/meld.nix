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
        home.packages = [ pkgs.meld ];
        programs.git.settings.diff.guitool = "meld";
      };
    };
}
