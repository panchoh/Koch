{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.libvirt;
in
{
  options.traits.os.libvirt = {
    enable = lib.mkEnableOption "libvirt" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${box.userName or "alice"}.extraGroups = [ "libvirtd" ];

    environment.systemPackages = [
      pkgs.libguestfs
      pkgs.guestfs-tools
      pkgs.cloud-utils
    ];

    # REVIEW: Remove when https://nixpkgs-tracker.ocfox.me/?pr=451252 gets through
    systemd.services.libvirtd-config.enableStrictShellChecks = false;

    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
    };
  };
}
