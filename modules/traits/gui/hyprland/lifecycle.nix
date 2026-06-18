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
        wayland.windowManager.hyprland = {
          settings = {
            on = {
              _args = [
                "window.kill"
                (lib.generators.mkLuaInline ''
                  function(w)
                    hl.notification.create({
                      text = "Headshot! (via hyprctl kill) : " .. w.class .. "." .. w.title,
                      timeout = 5000,
                      icon = "INFO" })
                  end
                '')
              ];
            };
            bind =
              {
                # TODO: replace bare exit() call with hyprshutdown
                # https://wiki.hypr.land/Hypr-Ecosystem/hyprshutdown/
                "CONTROL + ALT + BackSpace" = "hl.dsp.exit()";
                "SUPER + Q" = "hl.dsp.force_renderer_reload()";
                "SUPER + X" = "hl.dsp.window.close()";
                "SUPER + SHIFT + X" = "hl.dsp.window.kill()";
                "SUPER + CONTROL + X" = ''hl.dsp.exec_cmd("hyprctl kill")'';
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
      };
    };
}
