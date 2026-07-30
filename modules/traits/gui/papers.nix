{
  flake = {
    homeModules.default =
      {
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.hm.papers;
      in
      {
        options.traits.hm.papers = {
          enable = lib.mkEnableOption "GNOME Papers" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.papers
          ];

          xdg.mimeApps.defaultApplications."application/pdf" = "org.gnome.Papers.desktop";
        };
      };
  };
}
