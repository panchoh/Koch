{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.pay-respects = {
          enable = lib.mkEnableOption "pay-respects" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        ...
      }:

      let
        cfg = nixosConfig.traits.pay-respects;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.pay-respects.enable = true;
        };
      };
  };
}
