{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.k9s = {
          enable = lib.mkEnableOption "K9s" // {
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
        cfg = nixosConfig.traits.k9s;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.k9s.enable = true;
        };
      };
  };
}
