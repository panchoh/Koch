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
          # https://wiki.hypr.land/Configuring/Basics/Variables/#binds
          # https://github.com/hyprwm/Hyprland/pull/352/files
          config.binds = {
            allow_workspace_cycles = true;
            hide_special_on_workspace_change = true;
            workspace_back_and_forth = false;
            workspace_center_on = 1;
          };
          bind =
            (
              {
                # Switch to previous workspace
                "SUPER + A" = "previous_per_monitor";

                # Cycle left through active workspaces
                "SUPER + ALT + bracketleft" = "e-1";

                # Cycle right through active workspaces
                "SUPER + ALT + bracketright" = "e+1";

                # Cycle left through active workspaces
                "SUPER + Left" = "e-1";

                # Cycle right through active workspaces
                "SUPER + Right" = "e+1";
              }
              |> lib.mapAttrsToList (
                keys: workspace: {
                  _args = [
                    keys
                    (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "${workspace}" })'')
                  ];
                }
              )
            )
            ++ (
              (lib.range 1 10)
              |> lib.concatMap (
                ws:
                let
                  wsID = toString ws;
                  key = toString (lib.mod ws 10);
                in
                [
                  {
                    _args = [
                      "SUPER + ${key}"
                      # Switch workspaces with SUPER + [0-9]
                      (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${wsID} })")
                    ];
                  }
                  {
                    _args = [
                      "SUPER + SHIFT + ${key}"
                      # Move active window to a workspace with SUPER + SHIFT + [0-9]
                      (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${wsID}, follow = false })")
                    ];
                  }
                ]
              )
            );
        };
      };
    };
}
