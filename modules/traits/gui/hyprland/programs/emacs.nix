{
  flake.homeModules.default =
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
          # https://github.com/hyprwm/Hyprland/issues/3073
          misc.focus_on_activate = true;
          workspace = [
            "1, default:true, defaultName:Doom, on-created-empty: doom-emacs"
          ];
          bind = [
            "SUPER,       D, exec, doom-emacs"
            "SUPER,       E, exec, emacs"
            "SUPER SHIFT, E, exec, emacsclient --no-wait --reuse-frame"
          ];
        };
      };
    };
}
