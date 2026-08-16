{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.papers = {
          enable = lib.mkEnableOption "GNOME Papers" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.papers;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.papers ];
          xdg.mimeApps.defaultApplications."application/pdf" = "org.gnome.Papers.desktop";
        };
      };
  };
}
