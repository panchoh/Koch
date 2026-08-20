{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.traits.intel;
    in
    {
      options.traits.intel = {
        enable = lib.mkEnableOption "intel" // {
          # REVIEW: when eventually available, set to config.hardware.facter.detected.graphics.intel.enable
          default = config.hardware.facter.detected.graphics.enable;
        };
      };

      config = lib.mkIf cfg.enable {

        nixpkgs.config.allowUnfreePackages = [ "intel-ocl" ];

        hardware = {

          intel-gpu-tools.enable = true;

          graphics.extraPackages = [
            # https://nixos.wiki/wiki/Accelerated_Video_Playback
            pkgs.libva-vdpau-driver
            pkgs.libvdpau-va-gl
          ];
        };
      };
    };
}
