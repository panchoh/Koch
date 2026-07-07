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
      cfg = config.traits.hm.emacs;
    in
    {
      options.traits.hm.emacs = {
        enable = lib.mkEnableOption "Emacs" // {
          default = box.isStation;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.emacs = {
          enable = true;

          # Pick one:
          # package = pkgs.emacs-igc-pgtk;
          # package = pkgs.emacs-git-pgtk;
          package = pkgs.emacs31-pgtk;
          # package = pkgs.emacs30-pgtk;
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
}
