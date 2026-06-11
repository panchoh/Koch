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
            key_press_enables_dpms = true;
            mouse_move_enables_dpms = true;
          };
        };
        # https://wiki.hypr.land/Hypr-Ecosystem/hypridle/
        services.hypridle = {
          enable = true;
          settings = {
            general.after_sleep_cmd = ''
              hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
            '';
            listener = [
              {
                timeout = 300;
                on-timeout = ''
                  hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
                '';
                on-resume = ''
                  hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
                '';
              }
            ];
          };
        };
      };
    };
}
