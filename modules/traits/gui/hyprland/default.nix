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
        cfg = config.traits.hyprland;
      in
      {
        options.traits.hyprland = {
          enable = lib.mkEnableOption "Hyprland" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          programs.hyprland.enable = true;
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
        cfg = nixosConfig.traits.hyprland;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [ pkgs.d-spy ];

          # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
          wayland.windowManager.hyprland = {
            enable = true;
            package = null;
            portalPackage = null;
          };
        };
      };
  };
}
