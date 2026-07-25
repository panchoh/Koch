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
          bind = [
            {
              _args = [
                "SUPER + SUPER_L"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill fuzzel || fuzzel")'')
                { release = true; }
              ];
            }
          ];
        };
      };
    };
}
