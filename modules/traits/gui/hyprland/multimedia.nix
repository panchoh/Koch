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
          # Multimedia
          # https://wiki.hypr.land/Configuring/Basics/Binds/#media
          {
            _args = [
              "XF86AudioMute"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              "CONTROL + XF86AudioLowerVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "CONTROL + XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "SHIFT + XF86AudioLowerVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "SHIFT + XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 6%+")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "ALT + XF86AudioLowerVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 12%-")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "ALT + XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 12%+")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86AudioPrev"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl previous")'')
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86AudioPlay"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl play-pause")'')
            ];
          }
          {
            _args = [
              "XF86AudioNext"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl next")'')
              { repeating = true; }
            ];
          }
        ];
      };
    };
}
