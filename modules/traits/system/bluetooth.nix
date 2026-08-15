{
  flake.nixosModules.default =
    {
      config,
      lib,
      ...
    }:

    let
      cfg = config.hardware.facter.detected.bluetooth;
    in
    {
      config = lib.mkIf cfg.enable {

        # https://wiki.nixos.org/wiki/Bluetooth
        hardware.bluetooth.powerOnBoot = false;

        # TODO: explore https://github.com/bluez/bluez/blob/master/src/main.conf
        # hardware.bluetooth.settings = { };

        services.blueman.enable = true;
      };
    };
}
