{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.libvirt;
      in
      {
        options.traits.libvirt = {
          enable = lib.mkEnableOption "libvirt" // {
            default = true;
          };
        };

        options.traits.virt-manager = {
          enable = lib.mkEnableOption "virt-manager" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          users.users.${box.userName or "alice"}.extraGroups = [ "libvirtd" ];

          environment.systemPackages = [
            pkgs.libguestfs
            pkgs.guestfs-tools
            pkgs.cloud-utils
          ];

          virtualisation = {
            spiceUSBRedirection.enable = true;

            libvirtd = {
              enable = true;
              nss.enableGuest = true;
              qemu.runAsRoot = false;
            };
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.virt-manager;
      in
      {
        config = lib.mkIf cfg.enable {
          home.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

          home.packages = [
            pkgs.virt-manager
            pkgs.virt-viewer
          ];

          # https://github.com/virt-manager/virt-manager/blob/main/data/org.virt-manager.virt-manager.gschema.xml
          dconf.settings = {
            "org/virt-manager/virt-manager" = {
              xmleditor-enabled = true;
            };

            "org/virt-manager/virt-manager/confirm" = {
              forcepoweroff = false;
            };

            "org/virt-manager/virt-manager/connections" = {
              autoconnect = [ "qemu:///system" ];
              uris = [ "qemu:///system" ];
            };

            "org/virt-manager/virt-manager/new-vm" = {
              firmware = "uefi";
            };

            "org/virt-manager/virt-manager/stats" = {
              enable-disk-poll = true;
              enable-net-poll = true;
              enable-memory-poll = true;
            };

            "org/virt-manager/virt-manager/vmlist-fields" = {
              disk-usage = true;
              network-traffic = true;
              cpu-usage = true;
              host-cpu-usage = true;
              memory-usage = true;
            };
          };
        };
      };
  };
}
