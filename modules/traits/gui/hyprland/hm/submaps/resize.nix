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

    wayland.windowManager.hyprland = {

      settings.bind = [ "SUPER, R, submap, resize" ];

      submaps."resize".settings = {

        bind = [
          "SUPER  , R,      submap, reset"
          "       , Escape, submap, reset"
          "       , Return, submap, reset"
        ];

        binde = [
          "CONTROL, L,      resizeactive,    1    0"
          "CONTROL, H,      resizeactive,   -1    0"
          "CONTROL, K,      resizeactive,    0   -1"
          "CONTROL, J,      resizeactive,    0    1"
          "       , L,      resizeactive,    8    0"
          "       , H,      resizeactive,   -8    0"
          "       , K,      resizeactive,    0   -8"
          "       , J,      resizeactive,    0    8"
          "SHIFT  , L,      resizeactive,  128    0"
          "SHIFT  , H,      resizeactive, -128    0"
          "SHIFT  , K,      resizeactive,    0 -128"
          "SHIFT  , J,      resizeactive,    0  128"
          "ALT    , L,      resizeactive,  512    0"
          "ALT    , H,      resizeactive, -512    0"
          "ALT    , K,      resizeactive,    0 -512"
          "ALT    , J,      resizeactive,    0  512"
        ];
      };
    };
  };
}
