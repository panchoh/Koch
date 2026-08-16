{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.neomutt = {
          enable = lib.mkEnableOption "NeoMutt" // {
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
        cfg = nixosConfig.traits.neomutt;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.neomutt.enable = true;
        };
      };
  };
}
