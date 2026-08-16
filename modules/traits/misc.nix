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
        cfg = config.traits.misc;
      in
      {
        options.traits.misc = {
          enable = lib.mkEnableOption "misc" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          nixpkgs.config.allowUnfreePackages = [
            "celestia"
            "celestia-content"
            "discord"
            "discord-unwrapped"
            "bgnet"
            "zoom"
          ];
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = nixosConfig.traits.misc;
      in
      {

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.dmidecode
            pkgs.efibootmgr
            pkgs.gptfdisk
            pkgs.parted
            pkgs.psmisc
            pkgs.sysstat
            pkgs.sysfsutils
            pkgs.pciutils
            pkgs.usbutils
            pkgs.usbtop
            pkgs.iotop-c
            pkgs.smartmontools
            pkgs.hdparm
            pkgs.nvme-cli
            pkgs.sg3_utils
            pkgs.lm_sensors
          ]
          ++ lib.optionals (box.isStation or false) [
            pkgs.ldns
            pkgs.doggo
            pkgs.nmap
            pkgs.speedtest-go
            pkgs.ipcalc
            pkgs.certbot
            pkgs.curl
            pkgs.wget2
            pkgs.xh
            pkgs.restish
            pkgs.slumber

            pkgs.moreutils
            pkgs.fx
            pkgs.yq-go
            pkgs.hwloc
            pkgs.b3sum
            pkgs.lzop
            pkgs.unzip
            pkgs.zip

            pkgs.binutils
            pkgs.dua
            pkgs.duf
            pkgs.dust
            pkgs.dysk
            pkgs.file
            pkgs.gdu

            pkgs.rdfind
            pkgs.fdupes
            pkgs.rmlint
            pkgs.raider
            pkgs.czkawka
            pkgs.fclones
            pkgs.fclones-gui

            pkgs.gnutls
            pkgs.zstd
            pkgs.udftools

            pkgs.inotify-info

            pkgs.hwinfo
            pkgs.nixos-facter

            pkgs.bc
            pkgs.cdrkit

            pkgs.intel-gpu-tools

            pkgs.glow

            pkgs.entr

            pkgs.pv

            pkgs.nixos-anywhere

            # Show details about outdated packages in your NixOS system
            # https://github.com/trofi/nix-olde
            pkgs.nix-olde

            pkgs.ddrescue
            # REVIEW: In the chop list because it still depends on GTK 2
            # https://github.com/NixOS/nixpkgs/issues/410814
            # pkgs.ddrescueview

            # https://github.com/blacknon/hwatch
            pkgs.hwatch

            pkgs.recode

            pkgs.whois

            pkgs.pdf4qt
            pkgs.pdfchain
            pkgs.pdfcpu
            pkgs.pdfgrep
            pkgs.pdftk

            pkgs.asciinema
            pkgs.asciinema-agg
            pkgs.asciinema-scenario

            pkgs.viddy

            # GitHub Actions SHA pinners
            pkgs.pinact
            pkgs.ratchet

            # https://beej.us/guide/bgnet/
            pkgs.bgnet

            # Audio
            pkgs.flac
            pkgs.cliamp
            pkgs.audible-cli
            pkgs.aaxtomp3
            pkgs.libation

            pkgs.mission-center
            pkgs.v4l-utils

            pkgs.ffmpeg
            pkgs.vlc
            pkgs.mkvtoolnix
            pkgs.gimp3
            pkgs.inkscape
            pkgs.youtube-tui
            pkgs.zoom-us

            pkgs.discord
            pkgs.dissent
            # TODO: finish setting up nheko and/or fractalfor Matrix comms
            # pkgs.nheko
            # pkgs.fractal
            # REVIEW: uncomment when fixed upstream
            # https://github.com/NixOS/nixpkgs/issues/537728
            # pkgs.session-desktop

            pkgs.wormhole-william

            pkgs.zizmor

            # Astronomy
            pkgs.stellarium
            # REVIEW: build broken
            # pkgs.celestia
          ];
        };
      };
  };
}
