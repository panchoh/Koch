{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.hm.man;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mangl # https://github.com/zigalenarcic/mangl
    ];

    # TODO: generate ~/.manglrc
  };
}
