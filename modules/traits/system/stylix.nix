{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      inputs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.os.stylix;
    in
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      options.traits.os.stylix = {
        enable = lib.mkEnableOption "Stylix" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        fonts = {
          enableDefaultPackages = true;
          packages = [
            pkgs.corefonts
            pkgs.aporetic
          ];
        };

        stylix = {
          enable = true;
          targets.plymouth.enable = false;

          # Either image or base16Scheme is required
          base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

          homeManagerIntegration = {
            followSystem = true;
            autoImport = true;
          };

          opacity.popups = 0.80;

          cursor = {
            package = pkgs.banana-cursor;
            name = "Banana";
            size = 42;
          };

          fonts = {
            serif = {
              name = "Aporetic Serif Mono";
              package = pkgs.aporetic;
            };

            sansSerif = {
              name = "Aporetic Sans Mono";
              package = pkgs.aporetic;
            };

            monospace = {
              name = "Aporetic Sans Mono";
              package = pkgs.aporetic;
            };

            emoji = {
              name = "OpenMoji Color";
              package = pkgs.openmoji-color;
            };

            sizes = lib.mapAttrs (_name: value: if box.isLaptop or false then value - 2 else value) {
              desktop = 14;
              applications = 14;
              terminal = 14;
              popups = 12;
            };
          };
        };
      };
    };
}
