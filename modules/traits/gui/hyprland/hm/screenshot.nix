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
      pkgs.grim
      pkgs.grimblast
      pkgs.hyprpicker
      pkgs.jq
      pkgs.libnotify # For notify-send
      pkgs.satty # TODO: also configure hyprland keybinding
      pkgs.slurp
      pkgs.wl-clipboard
      # REVIEW
      # pkgs.wl-clipboard-rs
    ];
    programs.hyprshot = {
      enable = true;
      saveLocation = "${config.home.homeDirectory}/screenshots";
    };
    wayland.windowManager.hyprland.settings.bind = [
      # TODO: evaluate hyprshot¹ and grimblast²
      # ¹: https://github.com/Gustash/Hyprshot/blob/main/hyprshot
      # ²: https://github.com/hyprwm/contrib/blob/main/grimblast/grimblast
      #
      # If hyprshot is selected, drop explicit deps shown up
      # already provided by:
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/hy/hyprshot/package.nix#L53

      # Screenshots
      # "SUPER,       P, exec, grimblast save active"
      # "SUPER SHIFT, P, exec, grimblast save screen"
      # "SUPER ALT,   P, exec, grimblast save output"
      # "SUPER CTRL,  P, exec, grimblast save area"
      "     , Print, exec, grimblast save active"
      "SHIFT, Print, exec, grimblast save screen"
      "ALT,   Print, exec, grimblast save output"
      "CTRL,  Print, exec, grimblast save area"
    ];
  };
}
