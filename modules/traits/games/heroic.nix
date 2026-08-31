{
  flake = {

    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.heroic = {
          enable = lib.mkEnableOption "Heroic Games Launcher" // {
            default = false;
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
        cfg = nixosConfig.traits.heroic;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.heroic ];
        };
      };
  };
}
