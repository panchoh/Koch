{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.mpv = {
          enable = lib.mkEnableOption "mpv" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        config,
        nixosConfig,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = nixosConfig.traits.mpv;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [

            pkgs.drm_info
            pkgs.playerctl

            # for Emacs’ org-pomodoro
            (pkgs.writeShellApplication {
              name = "mpv-via-hdmi";

              runtimeInputs = [
                config.programs.mpv.package
              ];

              text = ''
                #echo "$@" >> /tmp/mpv-via-hdmi.log
                exec mpv --audio-device=alsa/hdmi:CARD=PCH,DEV=0 "$@"
              '';
            })
          ];

          services.playerctld.enable = true;

          wayland.windowManager.hyprland.settings = {
            window_rule = [
              {
                match.class = "^mpv$";
                float = true;
                center = true;
                no_anim = true;
                no_dim = true;
                content = "video";
              }
            ];
          };

          programs = {

            mangohud.enable = true;

            mpv = {

              enable = true;
              scripts = [ pkgs.mpvScripts.mpris ];

              bindings = {
                ENTER = "playlist-next force";
                WHEEL_UP = "seek 10";
                WHEEL_DOWN = "seek -10";
                "Alt+0" = "set window-scale 0.5";
              };

              # https://github.com/mpv-player/mpv/issues/12082#issuecomment-1666545541
              defaultProfiles = [ (if !(box.hasBeefyGPU or true) then "fast" else "high-quality") ];

              config =
                let
                  gpus = nixosConfig.hardware.facter.report.hardware.graphics_card or [ ];
                  hasNvidia = builtins.any (gpu: (gpu.vendor.name or "") == "nVidia Corporation") gpus;
                in
                {
                  fullscreen = true;
                  sub-auto = "fuzzy";
                  gpu-api = "vulkan";
                  hwdec = "vaapi";
                }
                // lib.optionalAttrs hasNvidia {
                  hwdec = "nvdec";
                  hwdec-codecs = "h264,hevc,vp8,vp9,vc1";
                };

              profiles = {
                alsa-mm1 = {
                  profile-desc = "Sound via alsa interface: MM-1";
                  audio-device = "alsa/iec958:CARD=MM1,DEV=0";
                };

                alsa-x = {
                  profile-desc = "Sound via alsa interface: X";
                  audio-device = "alsa/iec958:CARD=X,DEV=0";
                };

                alsa-hdmi = {
                  profile-desc = "Sound via alsa interface: HDMI";
                  audio-device = "alsa/hdmi:CARD=PCH,DEV=0";
                };

                "extension.mkv" = {
                  keep-open = true;
                  volume-max = "150";
                };

                "extension.mp4" = {
                  keep-open = true;
                  volume-max = "150";
                };

                "extension.gif" = {
                  osc = "no";
                  loop-file = true;
                };

                "protocol.dvd" = {
                  profile-desc = "profile for dvd:// streams";
                  alang = "en";
                };
              };
            };
          };
        };
      };
  };
}
