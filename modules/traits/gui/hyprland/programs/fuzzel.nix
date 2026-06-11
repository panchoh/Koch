{
  flake.homeModules.default =
    {
      config,
      lib,
      nixosConfig,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
      size = toString (nixosConfig.stylix.fonts.sizes.desktop + 2);
    in
    {
      config = lib.mkIf cfg.enable {
        programs.fuzzel = {
          enable = true;
          settings = {
            main = {
              font = lib.mkForce "Iosevka Extended:size=${size}";
              layer = "overlay";
              terminal = lib.getExe config.programs.foot.package;
            };
          };
        };
        wayland.windowManager.hyprland.settings = {
          layer_rule = [
            {
              match.namespace = "^launcher$";
              xray = true;
              dim_around = true;
            }
          ];
          # Alternatively:
          # Start fuzzel opens fuzzel on first press, closes it on second
          # bindr = SUPER, SUPER_L, exec, pkill fuzzel || fuzzel
          bind = [
            {
              _args = [
                "SUPER + P"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("fuzzel")'')
              ];
            }
          ];
        };
      };
    };
}
