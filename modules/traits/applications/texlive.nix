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
        # REVIEW: Disabling until this can be reworked on Home Manager
        programs.texlive = {
          enable = false;
          extraPackages = tpkgs: {
            inherit (tpkgs) scheme-full;
          };
        };
      };
    };
}
