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
      config =
        let
          # https://wiki.hypr.land/Configuring/Basics/Binds/#disabling-keybinds-with-one-master-keybind
          keys = "SUPER + CONTROL + ALT + SHIFT + Escape";
        in
        lib.mkIf cfg.enable {
          wayland.windowManager.hyprland = {

            settings.bind = [
              {
                _args = [
                  keys
                  (lib.generators.mkLuaInline ''hl.dsp.submap("clean")'')
                ];
              }
            ];

            submaps.clean.settings.bind = [
              {
                _args = [
                  keys
                  (lib.generators.mkLuaInline ''hl.dsp.submap("reset")'')
                ];
              }
            ];
          };
        };
    };
}
