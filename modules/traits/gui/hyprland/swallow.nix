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
          config.misc = {
            # Enables:
            # xkbcli interactive-wayland --enable-compose
            # wev -f wl_keyboard
            enable_swallow = true;
            swallow_regex = "^foot(client)?$";
            swallow_exception_regex = "^.*(xkbcli|wev).*$";
          };
          bind = [
            {
              _args = [
                "SUPER + S"
                (lib.generators.mkLuaInline "hl.dsp.window.toggle_swallow()")
              ];
            }
          ];
        };
      };
    };
}
