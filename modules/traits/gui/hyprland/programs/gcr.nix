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
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.class = "^(gcr-prompter)$";
            no_anim = true;
            xray = true;
            dim_around = true;
            stay_focused = true;
          }
        ];
      };
    };
}
