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
      # For notify-send, used by programs.foot.settings.desktop-notifications.command’s default value
      pkgs.libnotify
    ];
    programs.foot = {
      enable = true;
      settings = {
        bell = {
          urgent = true;
          notify = true;
          visual = true;
        };
        main.pad = "0x0";
        mouse.hide-when-typing = true;
      };
    };
    wayland.windowManager.hyprland.settings = {
      animation = [
        "specialWorkspace, 1, 8, default, slidefadevert 20%"
      ];
      workspace = [
        "special:Foot, on-created-empty: foot"
      ];
      bind = [
        "SUPER SHIFT, Return, exec, foot"
        # Select / Move to scratchpad
        "SUPER,       grave, togglespecialworkspace,        Foot"
        "SUPER SHIFT, grave, movetoworkspacesilent, special:Foot"
      ];
    };
  };
}
