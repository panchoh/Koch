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
        # https://wiki.hypr.land/Configuring/Basics/Binds/#submaps
        wayland.windowManager.hyprland = {
          settings.bind = [
            {
              _args = [
                "SUPER + R"
                (lib.generators.mkLuaInline ''hl.dsp.submap("resize")'')
              ];
            }
          ];
          submaps.resize.settings.bind =
            (
              {
                "CONTROL+ L" = {
                  x = 1;
                  y = 0;
                };
                "CONTROL+ H" = {
                  x = -1;
                  y = 0;
                };
                "CONTROL+ K" = {
                  x = 0;
                  y = -1;
                };
                "CONTROL+ J" = {
                  x = 0;
                  y = 1;
                };
                "L" = {
                  x = 32;
                  y = 0;
                };
                "H" = {
                  x = -32;
                  y = 0;
                };
                "K" = {
                  x = 0;
                  y = -32;
                };
                "J" = {
                  x = 0;
                  y = 32;
                };
                "SHIFT + L" = {
                  x = 128;
                  y = 0;
                };
                "SHIFT + H" = {
                  x = -128;
                  y = 0;
                };
                "SHIFT + K" = {
                  x = 0;
                  y = -128;
                };
                "SHIFT + J" = {
                  x = 0;
                  y = 128;
                };
                "ALT + L" = {
                  x = 512;
                  y = 0;
                };
                "ALT + H" = {
                  x = -512;
                  y = 0;
                };
                "ALT + K" = {
                  x = 0;
                  y = -512;
                };
                "ALT + J" = {
                  x = 0;
                  y = 512;
                };
              }
              |> lib.mapAttrsToList (
                keys: delta: {
                  _args = [
                    keys
                    (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = ${toString delta.x}, y = ${toString delta.y}, relative = true })")
                    { repeating = true; }
                  ];
                }
              )
            )
            ++ (
              {
                "SUPER + L" = {
                  x = 512;
                  y = 0;
                };
                "SUPER + H" = {
                  x = -512;
                  y = 0;
                };
                "SUPER + K" = {
                  x = 0;
                  y = -512;
                };
                "SUPER + J" = {
                  x = 0;
                  y = 512;
                };
              }
              |> lib.mapAttrsToList (
                keys: delta: {
                  _args = [
                    keys
                    (lib.generators.mkLuaInline "hl.dsp.window.move({ x = ${toString delta.x}, y = ${toString delta.y}, relative = true })")
                    { repeating = true; }
                  ];
                }
              )
            )
            ++ (
              [
                "Escape"
                "Return"
                "SUPER + R"
              ]
              |> map (keys: {
                _args = [
                  keys
                  (lib.generators.mkLuaInline ''hl.dsp.submap("reset")'')
                ];
              })
            )
            ++ [
              {
                _args = [
                  "catchall"
                  # https://wiki.hypr.land/Configuring/Basics/Binds/#catch-all
                  (lib.generators.mkLuaInline "hl.dsp.no_op()")
                ];
              }
            ];
        };
      };
    };
}
