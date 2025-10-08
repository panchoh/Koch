{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.man;
in
{
  imports = [
    ./mangl.nix
  ];

  options.traits.hm.man = {
    enable = lib.mkEnableOption "Manual pages" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    manual.html.enable = true;
    manual.json.enable = true;
    manual.manpages.enable = true;

    home = {
      sessionVariables.MANROFFOPT = "-P-i";
      packages = [
        pkgs.groff
        pkgs.man-pages
        pkgs.man-pages-posix
      ];
    };

    programs.man = {
      enable = true;
      generateCaches = true;
    };
  };
}
