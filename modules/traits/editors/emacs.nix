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
          package = pkgs.emacs31-pgtk;
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
