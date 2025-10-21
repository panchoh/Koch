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
        nixosConfig,
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
          wayland.windowManager.hyprland = {
            enable = true;
            package = nixosConfig.programs.hyprland.package;
          };
        };
      };
  };
}
