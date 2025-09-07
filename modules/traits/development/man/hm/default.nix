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
  options.traits.hm.man = {
    enable = lib.mkEnableOption "man" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    manual.html.enable = true;
    manual.json.enable = true;
    manual.manpages.enable = true;

    home.packages = [
      pkgs.man-pages
      pkgs.man-pages-posix
    ];

    programs.man = {
      enable = true;
      generateCaches = true;
    };
  };
}
