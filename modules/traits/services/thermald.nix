{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.thermald;
    in
    {
      options.traits.thermald = {
        enable = lib.mkEnableOption "thermald " // {
          default = true;
        };
      };

      # REVIEW: thermald: drop file when https://github.com/NixOS/nixpkgs/pull/555356 lands
      config = lib.mkIf cfg.enable {
        nixpkgs.overlays = [
          (final: prev: {
            thermald = prev.thermald.overrideAttrs (_old: {
              src = final.fetchFromGitHub {
                owner = "panchoh";
                repo = "thermal_daemon";
                rev = "7f2a5d09010c1ffa9ce53c4fe0e673bcc504ea67";
                hash = "sha256-ETS2V7m8HeJ3udAdLFQXmbYI23BbdmJkt7LdlOdHWdQ=";
              };
            });
          })
        ];
      };
    };
}
