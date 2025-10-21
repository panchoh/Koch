{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.os.podman;
    in
    {
      options.traits.os.podman = {
        enable = lib.mkEnableOption "Podman" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [
          pkgs.dive
          pkgs.podman-tui
          pkgs.podman-compose
        ]
        ++ lib.optionals (box.isStation or false) [
          pkgs.podman-desktop
        ];

        virtualisation = {
          podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
          };
        };
      };
    };
}
