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
    wayland.windowManager.hyprland.settings.bindl = [
      # Radios management
      # https://github.com/dwlocks/scripts-tools-config/blob/master/etc/rfkill-toggle
      # TODO: extract shell script to its own rfkill-toggle executable
      '', XF86WLAN, exec, sh -c '[[ "$(< /sys/class/rfkill/rfkill0/state)" == "1" ]] && rfkill block all || rfkill unblock all' ''
    ];
  };
}
