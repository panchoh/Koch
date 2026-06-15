{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:
      let
        cfg = config.traits.os.hyprland;
      in
      {
        config = lib.mkIf cfg.enable {
          hardware.acpilight.enable = true;
        };
      };

    homeModules.default =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.traits.hm.hyprland;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.brightnessctl ];
          wayland.windowManager.hyprland.settings = {
            bind = (
              {
                "XF86MonBrightnessDown" = "set 10%-";
                "XF86MonBrightnessUp" = "set 10%+";
                "XF86KbdBrightnessDown" = "--device=smc::kbd_backlight set 10%-";
                "XF86KbdBrightnessUp" = "--device=smc::kbd_backlight set 10%+";
              }
              |> lib.mapAttrsToList (
                keys: brctlargs: {
                  _args = [
                    keys
                    # https://en.wikipedia.org/wiki/Weber%E2%80%93Fechner_law
                    (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl --exponent ${brctlargs}")'')
                    { repeating = true; }
                  ];
                }
              )
            );
          };
        };
      };
  };
}
