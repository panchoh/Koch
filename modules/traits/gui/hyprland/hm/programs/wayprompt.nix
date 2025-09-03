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
    programs.wayprompt = {
      enable = true;
      settings.general.pin-square-amount = 32;
    };

    services.gpg-agent.pinentry.package = config.programs.wayprompt.package;

    wayland.windowManager.hyprland.settings.layerrule = [
      "xray 1,    wayprompt"
      "dimaround, wayprompt"
    ];
  };
}
