{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.misc;
    in
    {
      options.traits.hm.misc = {
        enable = lib.mkEnableOption "misc" // {
          default = true;
        };
      };

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

          pkgs.ldns
          pkgs.doggo
          pkgs.dogdns
          pkgs.nmap
          pkgs.speedtest-go
          pkgs.ipcalc

          pkgs.curl
          pkgs.wget2
          pkgs.xh
          pkgs.restish
          pkgs.slumber

          pkgs.moreutils
          pkgs.yq-go
          pkgs.hwloc
          pkgs.b3sum
          pkgs.unzip
          pkgs.zip

          pkgs.binutils
          pkgs.dua
          pkgs.duf
          pkgs.dust
          pkgs.dysk
          pkgs.file
          pkgs.fdupes
          pkgs.rdfind
          pkgs.czkawka
          pkgs.fclones
          pkgs.gnutls
          pkgs.zstd

          pkgs.inotify-info

          pkgs.bc
          pkgs.cdrkit

          pkgs.intel-gpu-tools

          pkgs.glow

          pkgs.entr

          pkgs.pv

          pkgs.fx
        ]
        ++ lib.optionals (box.isStation or false) [
          pkgs.nixos-anywhere

          pkgs.ddrescue
          pkgs.ddrescueview

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

          pkgs.pinact

          pkgs.bgnet

          pkgs.flac

          pkgs.mission-center
          pkgs.v4l-utils
          pkgs.libation
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
          pkgs.session-desktop

          pkgs.wormhole-william

          pkgs.stellarium
          pkgs.celestia
        ];
      };
    };
}
