{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.games.openarena;
    in
    {
      options.traits.games.openarena = {
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
      nixosConfig,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = nixosConfig.traits.games.openarena;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.openarena
        ];
      };
    };
}
