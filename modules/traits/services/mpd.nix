{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.os.mpd;
      in
      {
        options.traits.os.mpd = {
          enable = lib.mkEnableOption "MPD" // {
            default = (!box.isStation or false) && (box.hasMedia or false);
          };
        };

        config = lib.mkIf cfg.enable {
          services.mpd = {
            enable = true;
            musicDirectory = "/srv/media/audio";
            startWhenNeeded = true;
            extraConfig = ''
              audio_output {
                      type            "alsa"
                      name            "MM-1"
                      device          "hw:1,0"        # optional
                      #format         "44100:16:2"    # optional
                      format          "48000:16:2"    # optional
                      mixer_device    "hw:1"          # optional
                      mixer_control   "PCM"           # optional
                      mixer_index     "0"             # optional
              }
            '';
          };
        };
      };

    homeModules.default =
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
      };
  };
}
