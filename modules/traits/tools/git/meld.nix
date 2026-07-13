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
        home.packages = [ pkgs.meld ];
        programs.git.settings.diff.guitool = "meld";
      };
    };
}
