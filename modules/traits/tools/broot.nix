{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.broot = {
          enable = lib.mkEnableOption "broot" // {
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
        cfg = nixosConfig.traits.broot;
      in
      {
        config = lib.mkIf cfg.enable {

          # https://dystroy.org/broot/
          programs.broot = {

            enable = true;

            settings = {

              modal = true;

              # TODO: explore the tool and configure verbs et al.
              # verbs = [ { } ];
            };
          };
        };
      };
  };
}
