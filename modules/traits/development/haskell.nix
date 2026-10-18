{
  flake = {

    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.haskell = {
          enable = lib.mkEnableOption "Haskell" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        config,
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.haskell;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.ghc
            pkgs.cabal-install
            pkgs.haskell-language-server
            pkgs.hlint
          ];
        };
      };
  };
}
