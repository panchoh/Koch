{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.quickemu = {
          enable = lib.mkEnableOption "Quickemu" // {
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
        cfg = nixosConfig.traits.quickemu;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.quickemu
            pkgs.quickgui
          ];
        };
      };
  };
}
