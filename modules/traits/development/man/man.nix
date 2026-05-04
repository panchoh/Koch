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
        cfg = config.traits.os.man;
      in
      {
        options.traits.os.man = {
          enable = lib.mkEnableOption "Manual pages" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          documentation.dev.enable = true;
          documentation.man.man-db.enable = false;
          documentation.man.mandoc.enable = true;
          programs.less.enable = lib.mkForce false;
        };
      };

    homeModules.default =
      {
        config,
        lib,
        pkgs,
        nixosConfig,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.man;
      in
      {
        options.traits.hm.man = {
          enable = lib.mkEnableOption "Manual pages" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          manual.html.enable = true;
          manual.json.enable = true;
          manual.manpages.enable = true;

          home = {
            sessionVariables = lib.mkIf nixosConfig.documentation.man.man-db.enable {
              MANROFFOPT = "-P-i";
            };
            packages = [
              pkgs.man-pages
              pkgs.man-pages-posix
            ]
            ++ lib.optionals (nixosConfig.documentation.man.man-db.enable) [
              pkgs.groff
            ];

          };

          programs.man = {
            enable = true;
            man-db.enable = nixosConfig.documentation.man.man-db.enable;
            mandoc.enable = nixosConfig.documentation.man.mandoc.enable;
            generateCaches = nixosConfig.documentation.man.man-db.enable;
          };
        };
      };
  };
}
