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
        options.traits.os.hyprland = {
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
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.hyprland;
      in
      {
        options.traits.hm.hyprland = {
          enable = lib.mkEnableOption "Hyprland" // {
            default = box.isStation or false;
          };
        };
        config = lib.mkIf cfg.enable {
          home = {
            packages = [
              pkgs.d-spy
            ];
            # https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland/
            file."${config.xdg.configHome}/hypr/xdph.conf".text = ''
              screencopy {
                  allow_token_by_default = true
              }
            '';
          };
          wayland.windowManager.hyprland = {
            # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
            enable = true;
            package = null;
            portalPackage = null;
          };
        };
      };
  };
}
