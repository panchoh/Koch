{
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.flakeModules.disko
  ];

  flake.diskoConfigurations =
    let
      mkDiskoConfig = box: {
        assertions = [
          {
            assertion = box.diskDevice != "";
            message = "diskDevice not defined; set it to your disk device, e.g., /dev/vda";
          }
        ];

        disko.devices.disk.main = {
          type = "disk";
          device = box.diskDevice;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                label = "ESP";
                type = "EF00";
                size = "500M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  extraArgs = [
                    "-F32"
                    "-nESP"
                  ];
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              swap = {
                label = "swap";
                type = "8200";
                size = "4G";
                content = {
                  type = "swap";
                  # randomEncryption = true;
                };
              };
              root = {
                label = "root";
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  subvolumes =
                    let
                      sharedMountOptions = [
                        "compress=zstd:1"
                        "noatime"
                        "autodefrag"
                        "X-fstrim.notrim"
                      ];
                    in
                    {
                      "@" = {
                        mountpoint = "/";
                        mountOptions = sharedMountOptions;
                      };
                      "@home" = {
                        mountpoint = "/home";
                        mountOptions = sharedMountOptions;
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = sharedMountOptions;
                      };
                      "@var" = {
                        mountpoint = "/var";
                        mountOptions = sharedMountOptions;
                      };
                      "@srv" = {
                        mountpoint = "/srv";
                        mountOptions = sharedMountOptions;
                      };
                      "@snapshots" = {
                        mountpoint = "/.snapshots";
                        mountOptions = sharedMountOptions;
                      };
                    };
                };
              };
            };
          };
        };
      };
    in
    self.lib.boxen
    |> map (box: lib.nameValuePair box.hostName (mkDiskoConfig box))
    |> builtins.listToAttrs;
}
