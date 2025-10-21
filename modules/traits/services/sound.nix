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
        cfg = config.traits.os.sound;
      in
      {
        options.traits.os.sound = {
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
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.sound;
      in
      {
        options.traits.hm.sound = {
          enable = lib.mkEnableOption "sound" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.audacity
            pkgs.helvum
            pkgs.picard
            pkgs.pwvucontrol
            pkgs.qastools
            pkgs.qpwgraph
          ];
        };
      };
  };
}
