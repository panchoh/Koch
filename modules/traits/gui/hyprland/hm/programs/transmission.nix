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
      pkgs.transmission_4-gtk
    ];
    xdg.mimeApps.defaultApplications."x-scheme-handler/magnet" = "transmission-gtk.desktop";

    wayland.windowManager.hyprland.settings = {
      workspace = [
        "special:Transmission, on-created-empty: transmission-gtk"
      ];
      bind = [
        # Select / Move to special:Transmission workspace
        "SUPER,       Equal, togglespecialworkspace,         Transmission"
        "SUPER SHIFT, Equal, movetoworkspacesilent,  special:Transmission"
      ];
      windowrulev2 = [
        "workspace special:Transmission silent, class:^(transmission-gtk)$, title:^(Transmission)$"
        "center,                                class:^(transmission-gtk)$, title:^(Torrent Options)$"
      ];
    };
  };
}
