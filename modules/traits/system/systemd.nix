{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:

      let
        cfg = config.traits.systemd;
      in
      {
        options.traits.systemd = {
          enable = lib.mkEnableOption "systemd" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {

          systemd.enableStrictShellChecks = true;

          security = {

            # https://github.com/NixOS/nixpkgs/pull/468166/changes
            sudo.enable = false;

            run0 = {

              enable = true;
              sudo-shim.enable = true;

              persistentAuth = {
                enable = true;
                enableRemote = true;
              };
            };
          };

          # For nixos-rebuild switch --elevate=run0 --ask-elevate-password
          # For nixos-rebuild switch -S # works thanks to sudo-shim
          system.tools.nixos-rebuild.enableRun0Elevation = true;
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
        cfg = nixosConfig.traits.systemd;
      in
      {
        options.traits.systemd = {
          enable = lib.mkEnableOption "systemd" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.systemctl-tui
          ];
        };
      };
  };
}
