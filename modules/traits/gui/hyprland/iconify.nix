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
        wayland.windowManager.hyprland.settings.bind = [
          {
            _args = [
              "SUPER + W"
              # Simulate “iconify”
              # https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#minimize-windows-using-special-workspaces
              (lib.generators.mkLuaInline ''
                function ()
                  hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
                  hl.dispatch(hl.dsp.window.move({workspace = "+0"}))
                  hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
                  hl.dispatch(hl.dsp.window.move({workspace = "special:minimize"}))
                  hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
                end
              '')
            ];
          }
        ];
      };
    };
}
