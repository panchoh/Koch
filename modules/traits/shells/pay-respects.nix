{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.pay-respects;
    in
    {
      options.traits.hm.pay-respects = {
        enable = lib.mkEnableOption "pay-respects" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.pay-respects.enable = true;
      };
    };
}
