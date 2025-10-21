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
        wayland.windowManager.hyprland.settings.windowrulev2 = [
          "noanim 1,    class:^(gcr-prompter)$"
          "xray 1,      class:^(gcr-prompter)$"
          "dimaround 1, class:^(gcr-prompter)$"
          "stayfocused, class:^(gcr-prompter)$"
        ];
      };
    };
}
