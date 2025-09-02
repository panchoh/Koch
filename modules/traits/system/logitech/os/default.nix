{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.logitech;
in
{

  options.traits.os.logitech = {
    enable = lib.mkEnableOption "logitech" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
  };
}
