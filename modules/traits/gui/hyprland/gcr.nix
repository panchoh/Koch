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
        wayland.windowManager.hyprland.settings.windowrule = [
          "no_anim 1, xray 1, dim_around 1, stay_focused on, match:class ^(gcr-prompter)$"
        ];
      };
    };
}
