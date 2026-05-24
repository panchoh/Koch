{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.os.openarena;
    in
    {
      options.traits.os.openarena = {
        enable = lib.mkEnableOption "OpenArena" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        networking.firewall.allowedUDPPorts = [
          27960
          27961
          27962
          27963
        ];
      };
    };

  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.openarena;
    in
    {
      options.traits.hm.openarena = {
        enable = lib.mkEnableOption "OpenArena" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.openarena
        ];
      };
    };
}
