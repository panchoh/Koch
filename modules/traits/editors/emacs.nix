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
          package = pkgs.emacs-unstable-pgtk;
          extraPackages =
            epkgs: with epkgs; [
              nix-ts-mode
              vterm
              pdf-tools
              treesit-grammars.with-all-grammars
            ];
        };
      };
    };
}
