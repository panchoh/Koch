{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.texlive = {
          enable = lib.mkEnableOption "TeX Live" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        ...
      }:

      let
        cfg = nixosConfig.traits.texlive;
      in
      {
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

            enable = true;

            extraPackages = tpkgs: {
              inherit (tpkgs) scheme-full;
            };
          };
        };
      };
  };
}
