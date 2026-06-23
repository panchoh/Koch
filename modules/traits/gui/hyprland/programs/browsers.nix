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
          window_rule = [
            {
              match.initial_title = "Password Required - Mozilla Firefox";
              no_anim = true;
              xray = true;
              dim_around = true;
              stay_focused = true;
            }
          ];
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
