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
}
