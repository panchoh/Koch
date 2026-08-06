{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.os.bluetooth;
    in
    {
      options.traits.os.bluetooth = {
        enable = lib.mkEnableOption "Bluetooth®" // {
          default = box.hasBluetooth or false;
        };
      };

      config = lib.mkIf cfg.enable {

        # https://wiki.nixos.org/wiki/Bluetooth
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = false;

          # TODO: explore https://github.com/bluez/bluez/blob/master/src/main.conf
          # settings = {};
        };

        services.blueman.enable = true;
      };
    };
}
