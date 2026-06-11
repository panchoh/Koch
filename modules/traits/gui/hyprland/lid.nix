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
        # Lid management
        # https://www.reddit.com/r/hyprland/comments/1tbugwn/disabling_monitor_using_keybinds_in_055/
        # https://wiki.hypr.land/Configuring/Basics/Binds/#switches
        # https://github.com/hyprwm/Hyprland/discussions/11093
        wayland.windowManager.hyprland.settings.bind =
          {
            "switch:on:Lid Switch" = "true";
            "switch:off:Lid Switch" = "false";
          }
          |> lib.mapAttrsToList (
            keys: disabled: {
              _args = [
                keys
                (lib.generators.mkLuaInline ''
                  function()
                    hl.monitor({ output = "eDP-1", disabled = ${disabled} })
                  end
                '')
                { locked = true; }
              ];
            }
          );
      };
    };
}
