{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:
      let
        cfg = config.traits.os.hyprland;
      in
      {
        config = lib.mkIf cfg.enable {
          nixpkgs.overlays = [
            (final: prev: {
              wayprompt = prev.wayprompt.overrideAttrs (_old: {
                src = final.fetchFromGitHub {
                  owner = "panchoh";
                  repo = "wayprompt";
                  rev = "982058c87ad907894717d40e59cd2ce7c3a5a7c7";
                  hash = "sha256-2i9bDzd5NnMMRD4BWoRWDNwnKEPPRmpFtYyIYn21YS4=";
                };
              });
            })
          ];
        };
      };

    homeModules.default =
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
          programs.wayprompt = {
            enable = true;
            settings.general.pin-square-amount = 32;
          };

          services.gpg-agent.pinentry.package = config.programs.wayprompt.package;

          wayland.windowManager.hyprland.settings.layerrule = [
            "match:class wayprompt, xray 1"
            "match:class wayprompt, dim_around 1"
          ];
        };
      };
  };
}
