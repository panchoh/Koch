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
        wayland.windowManager.hyprland.settings.bind =
          {
            "SUPER + T" = ''hl.dsp.window.float({ action = "toggle" })'';
            "SUPER + F" = ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'';
            # maximize
            "SUPER + ALT + F" =
              ''hl.dsp.window.fullscreen_state({ internal = "1", client = "1", action = "toggle" })'';
            # fullscreen within window
            "SUPER + SHIFT + F" =
              ''hl.dsp.window.fullscreen_state({ internal = "0", client = "2", action = "toggle" })'';
          }
          |> lib.mapAttrsToList (
            keys: dispatcher: {
              _args = [
                keys
                (lib.generators.mkLuaInline dispatcher)
              ];
            }
          );
      };
    };
}
