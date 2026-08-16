{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.inori = {
          enable = lib.mkEnableOption "Inori" // {
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
        cfg = nixosConfig.traits.inori;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.inori.enable = true;
        };
      };
  };
}
