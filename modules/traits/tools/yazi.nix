{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.yazi = {
          enable = lib.mkEnableOption "yazi" // {
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
        cfg = nixosConfig.traits.yazi;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.yazi = {
            enable = true;
            enableFishIntegration = true;
          };
        };
      };
  };
}
