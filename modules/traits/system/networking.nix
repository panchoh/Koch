{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.networking;
      isLaptop = config.hardware.facter.report.hardware.system.form_factor or { } == "laptop";
    in
    {
      options.traits.networking = {
        enable = lib.mkEnableOption "networking" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = lib.optionals isLaptop [
          pkgs.iw
          pkgs.iwgtk
        ];

        programs = {
          mtr.enable = true;
          mtr.package = pkgs.mtr-gui;
        };

        hardware.facter.detected.dhcp.enable = false;

        networking = {
          hostName = box.hostName or "nixos";

          hosts = lib.optionalAttrs box.isRestricted or false {
            "0.0.0.0" = [
              "youtu.be"
              "youtube.com"
              "m.youtube.com"
              "music.youtube.com"
              "www.youtube.com"
              "www.youtubekids.com"
            ];
          };

          useDHCP = false;
          enableIPv6 = false;
          wireless.iwd.enable = isLaptop;
        };

        services = {
          # TODO: configure to protect caddy
          # reaction.enable = true;

          # TODO: add jails
          # fail2ban.enable = true;

          resolved = {
            enable = true;

            settings.Resolve = {
              DNSSEC = "true";
              LLMNR = "false";
            };
          };
        };

        systemd.network = {
          enable = true;
          wait-online.anyInterface = isLaptop;

          netdevs = {
            "10-mv0" = {
              netdevConfig = {
                Name = "mv0";
                Kind = "macvlan";
                MACAddress = box.macvlanAddr or "de:ad:be:ef:42:01";
              };

              macvlanConfig = {
                Mode = "bridge";
              };
            };
          };

          networks = {
            "10-wl" = {
              matchConfig.Name = "wl*";

              networkConfig = {
                DHCP = "ipv4";
                LinkLocalAddressing = "no";
                DNSSECNegativeTrustAnchors = "lemd wifi";
                IgnoreCarrierLoss = "3s";
                # DefaultRouteOnDevice = true;
              };

              linkConfig.RequiredForOnline = "no";

              dhcpV4Config = {
                UseDomains = true;
                RouteMetric = 600;
              };
            };

            "20-en" = {
              matchConfig.Name = "en*";
              macvlan = [ "mv0" ];

              networkConfig = {
                LinkLocalAddressing = "no";
              };

              linkConfig.RequiredForOnline = "no";
            };
            "30-mv0" = {
              matchConfig.Name = "mv0";

              networkConfig = {
                DHCP = "ipv4";
                IPv4Forwarding = true;
                LinkLocalAddressing = "no";
                DNSSECNegativeTrustAnchors = "lemd wifi";
              };

              dhcpV4Config = {
                UseDomains = true;
                RouteMetric = 100;
              };
            };
          };
        };
      };
    };

  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.networking;
      isLaptop = nixosConfig.hardware.facter.report.hardware.system.form_factor or { } == "laptop";
    in
    {
      config = lib.mkIf (cfg.enable && isLaptop) {

        programs.impala = {

          enable = true;

          settings = {

            ascii = false;
            switch = "r";
            mode = "station";
            esc_quit = false;

            device = {
              infos = "i";
              toggle_power = "o";
            };

            access_point = {
              start = "n";
              stop = "x";
            };

            station = {

              toggle_scanning = "s";

              known_network = {
                toggle_autoconnect = "t";
                remove = "d";
                show_all = "a";
                share = "p";
              };

              new_network = {
                show_all = "a";
                connect_hidden = "n";
              };
            };

            theme = {
              background = "dark gray";
              border = "green";
              text_color = "white";
              hidden_color = "dark gray";
              info_color = "green";
              warning_color = "yellow";
              error_color = "red";
            };
          };
        };
      };
    };
}
