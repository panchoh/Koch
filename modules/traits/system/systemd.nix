{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:
      let
        cfg = config.traits.os.systemd;
      in
      {
        options.traits.os.systemd = {
          enable = lib.mkEnableOption "systemd" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {
          systemd = {
            enableStrictShellChecks = true;
          };
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
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.traits.hm.systemd;
      in
      {
        options.traits.hm.systemd = {
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
