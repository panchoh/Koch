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
          bind =
            {
              "SUPER + slash" = "chromium";
              "SUPER + SHIFT + slash" = "google-chrome-stable";
              "SUPER + ALT + slash" = "firefox";
            }
            |> lib.mapAttrsToList (
              keys: browser: {
                _args = [
                  keys
                  (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${browser}")'')
                ];
              }
            );
        };
      };
    };
}
