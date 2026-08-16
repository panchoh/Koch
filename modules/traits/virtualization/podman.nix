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
      cfg = config.traits.podman;
    in
    {
      options.traits.podman = {
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

        # https://wiki.nixos.org/wiki/Podman
        users.users.${box.userName or "alice"}.extraGroups = [ "podman" ];

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
