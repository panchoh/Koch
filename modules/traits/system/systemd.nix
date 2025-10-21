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

          security.pam.services.systemd-run0 = { };
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
