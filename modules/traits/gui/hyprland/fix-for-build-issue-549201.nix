{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.os.hyprland;
      in
      {
        config = lib.mkIf cfg.enable {

          nixpkgs.overlays = [

            # REVIEW: drop once
            # https://github.com/NixOS/nixpkgs/pull/549253
            # lands on nixos-unstable
            (final: prev: {
              hyprland = prev.hyprland.overrideAttrs (oldAttrs: {
                postPatch = ''
                  # Relax glaze dependency
                  # FIXME: this shouldn't be needed once the upstream code will adopt it
                  substituteInPlace CMakeLists.txt start/CMakeLists.txt hyprpm/CMakeLists.txt \
                    --replace-fail "glaze 7...<8" "glaze"

                ''
                + (oldAttrs.postPatch or "");
              });
            })

          ];
        };
      };
  };
}
