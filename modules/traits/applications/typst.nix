{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.typst = {
          enable = lib.mkEnableOption "Typst" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.typst;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.typst
            pkgs.typstyle
            pkgs.tinymist
          ];
        };
      };
  };
}
