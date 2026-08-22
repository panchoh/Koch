{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.logitech;
    in
    {

      options.traits.logitech = {
        enable = lib.mkEnableOption "logitech" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.solaar.enable = true;
        hardware.logitech = {

          # prevent g15daemon udev rules from creeping in.
          lcd.devices = [ ];

          # for ltunify; see https://lekensteyn.nl/logitech-unifying.html
          wireless.enable = true;
        };
      };
    };
}
