{
  config,
  lib,
  nixosConfig,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.hyprland;
in
{
  imports = [
    ./services/hypridle.nix
    ./services/hyprpaper.nix
    ./services/hyprpolkitagent.nix
    ./services/mako.nix
    ./services/waybar.nix
    ./programs/foot.nix
    ./programs/browsers.nix
    ./programs/emacs.nix
    ./programs/fuzzel.nix
    ./programs/telegram.nix
    ./programs/transmission.nix
    ./programs/wayprompt.nix
    ./programs/hyprsysteminfo.nix
    ./monitor.nix
    ./mouse.nix
    ./keyboard.nix
    ./lid.nix
    ./radios.nix
    ./game.nix
    ./lifecycle.nix
    ./layouts/master.nix
    ./portal.nix
    ./workspace.nix
    ./fullscreen.nix
    ./iconify.nix
    ./smartgaps.nix
    ./screenshot.nix
    ./multimedia.nix
    ./style.nix
    ./swallow.nix
    ./ecosystem.nix
    ./gcr.nix
    ./submaps/resize.nix
  ];

  options.traits.hm.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = nixosConfig.programs.hyprland.package;
    };
  };
}
