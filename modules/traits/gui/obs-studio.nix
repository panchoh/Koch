{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.obs-studio = {
          enable = lib.mkEnableOption "OBS Studio" // {
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
        cfg = nixosConfig.traits.obs-studio;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.obs-studio = {
            enable = true;
            plugins = [ pkgs.obs-studio-plugins.wlrobs ];
          };
        };
      };
  };
}
