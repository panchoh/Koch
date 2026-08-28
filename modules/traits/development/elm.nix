{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.elm = {
          enable = lib.mkEnableOption "Elm" // {
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
        cfg = nixosConfig.traits.elm;
      in
      {
        config = lib.mkIf cfg.enable {

          # REVIEW: re-enable when build failures are addressed
          home.packages = [
            pkgs.elmPackages.elm
            # pkgs.elmPackages.elm-analyse
            # pkgs.elmPackages.elm-doc-preview
            pkgs.elmPackages.elm-format
            pkgs.elmPackages.elm-git-install
            # pkgs.elmPackages.elm-json
            # pkgs.elmPackages.elm-language-server
            pkgs.elmPackages.elm-live
            pkgs.elmPackages.elm-review
            pkgs.elmPackages.elm-spa
            pkgs.elmPackages.elm-test
            pkgs.elmPackages.elm-test-rs
          ];
        };
      };
  };
}
