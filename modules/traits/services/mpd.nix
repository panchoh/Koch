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
        cfg = config.traits.mpd-alsa;
      in
      {
        options.traits.mpd-alsa = {
          enable = lib.mkEnableOption "MPD (ALSA-only)" // {
            default = !(box.isStation or true) && (box.hasMedia or false);
          };
        };

        options.traits.mpd = {
          enable = lib.mkEnableOption "MPD" // {
            default = ((box.isStation or false) && (!config.traits.mpd-alsa.enable));
          };
        };

        config = lib.mkIf cfg.enable {

          services.mpd = {

            enable = true;
            startWhenNeeded = true;

            settings = {

              music_directory = "/srv/media/audio";

              audio_output = [
                {
                  type = "alsa";
                  name = "MM-1";
                  device = "hw:1,0"; # optional
                  #format = "44100:16:2"; # optional
                  format = "48000:16:2"; # optional
                  mixer_device = "hw:1"; # optional
                  mixer_control = "PCM"; # optional
                  mixer_index = "0"; # optional
                }
              ];
            };
          };
        };
      };

    homeModules.default =
      {
        config,
        nixosConfig,
        lib,
        box ? null,
        ...
      }:
      let
        cfg = nixosConfig.traits.mpd;
      in
      {
        config = lib.mkIf cfg.enable {

          services = {

            mpd-mpris.enable = true;

            mpd = {

              enable = true;
              musicDirectory = if !(box.hasMedia or true) then config.xdg.userDirs.music else "/srv/media/audio";
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
