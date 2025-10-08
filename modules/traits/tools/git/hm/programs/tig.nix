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
    home.packages = [
      pkgs.tig
    ];

    xdg.configFile."tig/config".text = ''
      set line-graphics = auto
      color cursor      black green bold
      color cursor-blur green black dim
    '';

    # Otherwise mouse wheel will wreak havoc
    programs.foot.settings.mouse.alternate-scroll-mode = false;
  };
}
