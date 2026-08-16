{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.abook = {
          enable = lib.mkEnableOption "Abook" // {
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
        cfg = nixosConfig.traits.abook;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.abook.enable = true;
        };
      };
  };
}
