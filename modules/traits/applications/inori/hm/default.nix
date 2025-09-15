{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.inori;
in
{
  options.traits.hm.inori = {
    enable = lib.mkEnableOption "Inori" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.inori.enable = true;
  };
}
