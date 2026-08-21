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
        options.traits.mpd-alsa =
          let
            hasMediaDrive = builtins.length (config.hardware.facter.report.hardware.disk or [ ]) > 1;
          in
          {
            enable = lib.mkEnableOption "MPD (ALSA-only)" // {
              default = !(box.isStation or true) && hasMediaDrive;
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
              musicDirectory =
                if builtins.length (nixosConfig.hardware.facter.report.hardware.disk or [ ]) > 1 then
                  "/srv/media/audio"
                else
                  config.xdg.userDirs.music;
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
