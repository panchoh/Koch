{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.ed = {
          enable = lib.mkEnableOption "GNU ed" // {
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
        cfg = nixosConfig.traits.ed;
      in
      {
        config = lib.mkIf cfg.enable {

          # https://en.wikipedia.org/wiki/Ed_(text_editor)
          # https://www.gnu.org/software/ed/
          # https://www.gnu.org/software/ed/manual/ed_manual.html
          home.packages = [
            pkgs.ed
          ];
        };
      };
  };
}
