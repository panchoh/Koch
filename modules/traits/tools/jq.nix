{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.jq = {
          enable = lib.mkEnableOption "jq" // {
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
        cfg = nixosConfig.traits.jq;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.jq.enable = true;
        };
      };
  };
}
