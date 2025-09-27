{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.powertop;
in
{
  options.traits.hm.powertop = {
    enable = lib.mkEnableOption "PowerTOP" // {
      default = box.isLaptop or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.powertop
    ];
  };
}
