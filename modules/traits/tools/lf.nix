{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.lf = {
          enable = lib.mkEnableOption "lf" // {
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
        cfg = nixosConfig.traits.lf;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.lf = {

            enable = true;

            settings = {
              icons = true;
              sixel = true;
            };
          };
        };
      };
  };
}
