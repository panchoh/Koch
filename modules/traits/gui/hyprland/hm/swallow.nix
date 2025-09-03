{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.hm.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [ "SUPER, S, toggleswallow," ];
      misc = {
        enable_swallow = true;
        swallow_regex = "^foot$";
        swallow_exception_regex = "^(.* *\.tex|wev.*|xkbcli.*)$";
      };
    };
  };
}
