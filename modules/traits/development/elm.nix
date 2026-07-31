{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.elm;
    in
    {
      options.traits.hm.elm = {
        enable = lib.mkEnableOption "Elm" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {

        home.packages = [
          pkgs.elmPackages.elm
          pkgs.elmPackages.elm-analyse
          pkgs.elmPackages.elm-doc-preview
          pkgs.elmPackages.elm-format
          pkgs.elmPackages.elm-git-install
          pkgs.elmPackages.elm-json
          pkgs.elmPackages.elm-language-server
          pkgs.elmPackages.elm-live
          pkgs.elmPackages.elm-review
          pkgs.elmPackages.elm-spa
          pkgs.elmPackages.elm-test
          pkgs.elmPackages.elm-test-rs
        ];
      };
    };
}
