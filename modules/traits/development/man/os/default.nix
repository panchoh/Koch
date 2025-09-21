{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.man;
in
{
  options.traits.os.man = {
    enable = lib.mkEnableOption "Manual pages" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    documentation.dev.enable = true;
  };
}
