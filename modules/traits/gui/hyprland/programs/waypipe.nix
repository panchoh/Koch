{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.waypipe
        ];
      };
    };
}
