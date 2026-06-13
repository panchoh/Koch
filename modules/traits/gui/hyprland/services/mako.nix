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
        services.mako = {
          enable = true;
          settings = {
            border-radius = 5;
            "mode=do-not-disturb" = {
              invisible = 1;
              default-timeout = 0;
              ignore-timeout = 1;
            };
          };
        };
        # Test notifications with:
        # notify-send -u critical -a Grendizer -- 'UFO in sight!' 'Control Tower at the Research Institute has detected unusual activity in the vecinity of Tokyo'
        wayland.windowManager.hyprland.settings = {
          layer_rule = [
            {
              match.namespace = "^notifications$";
              xray = true;
              dim_around = false;
            }
          ];
          bind =
            {
              # Switch to urgent or previous workspace
              "SUPER + U" = "hl.dsp.focus({ urgent_or_last = true })";
              "SUPER + Escape" = ''hl.dsp.exec_cmd("makoctl dismiss")'';
              "SUPER + SHIFT + Escape" = ''hl.dsp.exec_cmd("makoctl dismiss --all")'';
              "SUPER + ALT + Escape" = ''hl.dsp.exec_cmd("makoctl restore")'';
              # Togle DND
              "SUPER + CONTROL + Escape" = ''
                function ()
                    hl.dsp.exec_cmd("makoctl mode -t do-not-disturb")
                    hl.notification.create({ text = "DND toggled", duration = "2000", icon = "INFO" })
                end
              '';
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
}
