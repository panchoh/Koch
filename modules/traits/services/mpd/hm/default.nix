{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.mpd;
in
{
  options.traits.hm.mpd = {
    enable = lib.mkEnableOption "MPD" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      mpd-mpris.enable = true;
      mpd = {
        enable = true;
        musicDirectory = "/srv/media/audio";
        network.startWhenNeeded = true;
        extraConfig = ''
          audio_output {
                  type            "pipewire"
                  name            "PipeWire Sound Server"
          }
        '';
      };
    };
  };
}
