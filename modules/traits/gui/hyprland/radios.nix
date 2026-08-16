{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.settings.bind = [
          {
            _args = [
              "XF86WLAN"
              # Radios management
              # https://github.com/dwlocks/scripts-tools-config/blob/master/etc/rfkill-toggle
              # CAVEAT EMPTOR: fragile; if ethernet cable is plugged out/in, rfkill1 appears, hence the ?
              # TODO: extract shell script to its own rfkill-toggle executable
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("sh -c '[[ $(< /sys/class/rfkill/rfkill?/state) == 1 ]] && rfkill block all || rfkill unblock all'")'')
            ];
          }
        ];
      };
    };
}
