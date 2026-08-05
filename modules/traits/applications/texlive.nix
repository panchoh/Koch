{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.texlive;
    in
    {
      options.traits.hm.texlive = {
        enable = lib.mkEnableOption "TeX Live" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        # https://nixos.org/manual/nixpkgs/unstable/#sec-language-texlive-user-guide
        #
        # FIXME:
        # removal: texlive.combine is deprecated and will be removed from
        # Nixpkgs 27.05. Please switch to texliveSmall.withPackages. See
        # https://nixos.org/manual/nixpkgs/stable/#sec-language-texlive-user-guide. See
        # https://nixos.org/manual/nixpkgs/unstable#sec-problems
        #
        # See:
        # pkgs.texlive.scheme-*
        # pkgs.texlive.schemes.*
        #
        # collection-fontsrecommended, algorithms
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/typesetting/tex/texlive/tlpdb.nix
        programs.texlive = {
          enable = box.isStation or false;

          extraPackages = tpkgs: {
            inherit (tpkgs) scheme-full;
          };
        };
      };
    };
}
