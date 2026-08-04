{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.snapshot;
    in
    {
      options.traits.hm.snapshot = {
        enable = lib.mkEnableOption "Snapshot" // {
          default = box.hasCamera or false;
        };
      };

      config = lib.mkIf cfg.enable {

        home.packages = [
          pkgs.snapshot
        ];

        xdg.userDirs = {
          pictures = lib.mkForce "${config.home.homeDirectory}/Pictures";
          videos = lib.mkForce "${config.home.homeDirectory}/Videos";
        };
      };
    };
}
