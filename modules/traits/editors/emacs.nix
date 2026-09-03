{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.emacs = {
          enable = lib.mkEnableOption "Emacs" // {
            default = box.isStation;
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
        cfg = nixosConfig.traits.emacs;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.emacs = {

            enable = true;

            # Pick one:
            # package = pkgs.emacs-igc-pgtk;
            # package = pkgs.emacs-git-pgtk;
            package = pkgs.emacs-pgtk;
            # package = config.programs.doom-emacs.emacs;

            extraPackages = epkgs: [
              epkgs.nix-ts-mode
              epkgs.ghostel
              epkgs.vterm
              epkgs.pdf-tools
              epkgs.treesit-grammars.with-all-grammars
            ];
          };
        };
      };
  };
}
