{
  config,
  lib,
  pkgs,
  modulesPath,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.hardware;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ]
  ++ lib.optionals (box.hostName == "nixos") [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  options.traits.os.hardware = {
    enable = lib.mkEnableOption "hardware" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "sd_mod"
        ];
        kernelModules = [ ];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };

    nixpkgs.hostPlatform = lib.mkDefault box.system or "x86_64-linux";

    hardware = {
      cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      graphics = {
        enable = true;
        extraPackages = [
          # https://wiki.nixos.org/wiki/Intel_Graphics
          pkgs.vpl-gpu-rt
          # https://nixos.wiki/wiki/Accelerated_Video_Playback
          pkgs.intel-ocl
          pkgs.intel-compute-runtime
          pkgs.intel-media-driver
          pkgs.libva-vdpau-driver
          pkgs.libvdpau-va-gl
        ];
      };
    };

    security.wrappers.intel_gpu_top = {
      source = lib.getExe' pkgs.intel-gpu-tools "intel_gpu_top";
      owner = "root";
      group = "root";
      capabilities = "cap_perfmon+ep";
    };
  };
}
