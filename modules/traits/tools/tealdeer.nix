{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.tealdeer = {
          enable = lib.mkEnableOption "tealdeer" // {
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
        cfg = nixosConfig.traits.tealdeer;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.tealdeer = {
            enable = true;
            settings.updates.auto_update = true;
          };
        };
      };
  };
}
