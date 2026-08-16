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
        cfg = config.traits.sound;
      in
      {
        options.traits.sound = {
          enable = lib.mkEnableOption "sound" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          users.users.${box.userName or "alice"}.extraGroups = [ "audio" ];
          security.rtkit.enable = true;
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
        cfg = nixosConfig.traits.sound;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.audacity
            pkgs.crosspipe
            pkgs.picard
            pkgs.pwvucontrol
            pkgs.qastools
            pkgs.qpwgraph
          ];
        };
      };
  };
}
